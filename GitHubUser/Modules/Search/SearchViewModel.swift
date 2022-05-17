//
//  SearchViewModel.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 15/05/2022.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

final class SearchViewModel: NSObject, ViewModelType, PaginationType {
    // MARK: Lifecycle

    init(githubService: GitHubService = GitHubServiceImpl()) {
        self.githubService = githubService
        super.init()
        bindSearch()
        bindPageNumber()
        bindDidScrollToBottom()
        bindDidSelectIndexPath()
    }

    // MARK: Internal

    struct Input {
        let search: PublishRelay<String>
        let didScrollToBottom: PublishRelay<Void>
        let didSelectModel: PublishRelay<User>
        let loadingSubject: PublishSubject<Bool>
        let errorSubject: PublishSubject<APIError?>
        let contentSubject: BehaviorRelay<[User]>
    }

    struct Output {
        var isLoading: Driver<Bool>
        var error: Driver<APIError?>
        var content: Driver<[User]>? = nil
    }

    var showFollowActionSheet: (User) -> Void = { _ in }

    // Inputs
    lazy var input: Input = {
        let searchSubject = PublishRelay<String>()
        let loadingSubject = PublishSubject<Bool>()
        let didScrollToBottom = PublishRelay<Void>()
        let contentSubject = BehaviorRelay<[User]>(value: [])
        let errorSubject = PublishSubject<APIError?>()
        let didSelectModel = PublishRelay<User>()
        return Input(
            search: searchSubject,
            didScrollToBottom: didScrollToBottom,
            didSelectModel: didSelectModel,
            loadingSubject: loadingSubject,
            errorSubject: errorSubject,
            contentSubject: contentSubject
        )
    }()

    // Outputs
    lazy var output: Output = {
        let isLoading: Driver<Bool> = input.loadingSubject.asDriver(onErrorJustReturn: false)
        let error: Driver<APIError?> = input.errorSubject.asDriver(onErrorJustReturn: APIError.unkowned)
        let content: Driver<[User]> = input.contentSubject.asDriver(onErrorJustReturn: [])
        let output = Output(isLoading: isLoading, error: error, content: content)
        return output
    }()

    private(set) var maxValue: Int = 10
    private(set) var fetchPerPage: Int = 30
    private(set) var pageNumber: BehaviorRelay<Int> = .init(value: 1)

    var pageNumberObservable: Observable<Int> {
        pageNumber.asObservable()
    }

    // MARK: Private

    private let disposeBag = DisposeBag()
    private let githubService: GitHubService
    private var searchString: BehaviorRelay<String> = .init(value: "")

    private func bindSearch() {
        let observable: Observable<String>
        if UIApplication.shared.isRunningTestCases {
            observable = input.search.distinctUntilChanged()
        } else {
            observable = input
                .search
                .filter { !$0.isEmpty }
                .distinctUntilChanged()
                .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        }
        observable
            .flatMapLatest { [unowned self] term -> Single<SearchResponse> in
                self.input.errorSubject.onNext(nil)
                self.searchString.accept(term)
                return githubService
                    .search(search: .init(queryString: term, per_page: self.fetchPerPage))
                    .do(onError: { [unowned self] in
                        self.input.errorSubject.onNext(APIError.underlyingError($0))
                    }).catch { _ in .never() }
            }.subscribe { [unowned self] model in
                self.input.loadingSubject.onNext(false)
                if let items = model.element?.items, !items.isEmpty {
                    self.maxValue = (model.element?.totalCount ?? .zero) / self.fetchPerPage
                    var array = self.input.contentSubject.value
                    array.append(contentsOf: items)
                    self.input.contentSubject.accept(array)
                } else {
                    self.input.errorSubject.onNext(APIError.notFound)
                }
            }.disposed(by: disposeBag)
    }

    private func bindDidSelectIndexPath() {
        input
            .didSelectModel
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.showFollowActionSheet(model)
            })
            .disposed(by: disposeBag)
    }

    private func bindDidScrollToBottom() {
        input
            .didScrollToBottom
            .asObservable()
            .flatMap { [unowned self] _ -> Observable<Int> in
                guard self.pageNumber.value <= maxValue else { return .empty() }
                let newPageNumber = self.pageNumber.value + 1
                return Observable.just(newPageNumber)
            }
            .bind(to: pageNumber)
            .disposed(by: disposeBag)
    }

    private func bindPageNumber() {
        input.loadingSubject.onNext(true)
        pageNumber
            .filter { $0 != 1 }
            .subscribe(onNext: { [weak self] page in
                guard let self = self else { return }
                self.githubService
                    .search(search: .init(queryString: self.searchString.value, page: page))
                    .subscribe(
                        onSuccess: { [weak self] in
                            guard let self = self else { return }
                            self.maxValue = $0.totalCount / self.fetchPerPage
                            var array = self.input.contentSubject.value
                            array.append(contentsOf: $0.items)
                            self.input.contentSubject.accept(array)
                            self.input.loadingSubject.onNext(false)
                        },
                        onFailure: { [weak self] in
                            guard let self = self else { return }
                            self.input.errorSubject.onNext(APIError.underlyingError($0))
                            self.input.loadingSubject.onNext(false)
                        }
                    ).disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
