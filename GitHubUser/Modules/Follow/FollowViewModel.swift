//
//  FollowViewModel.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift
import UIKit

final class FollowViewModel: NSObject, ViewModelType {
    // MARK: Lifecycle

    init(isFollowers: Bool, user: User, githubService: GitHubService = GitHubServiceImpl()) {
        self.user = user
        self.isFollowers = isFollowers
        self.githubService = githubService
        super.init()
        bindOnViewDidLoad()
    }

    // MARK: Internal

    struct Input {
        let viewDidLoad: PublishRelay<Void>
        let loadingSubject: PublishSubject<Bool>
        let contentSubject: PublishSubject<[User]>
        let errorSubject: PublishSubject<APIError?>
    }

    struct Output {
        var isLoading: Driver<Bool>
        var error: Driver<APIError?>
        var content: Driver<[User]>? = nil
    }

    // Inputs
    lazy var input: Input = {
        let viewDidLoad = PublishRelay<Void>()
        let loadingSubject = PublishSubject<Bool>()
        let contentSubject = PublishSubject<[User]>()
        let errorSubject = PublishSubject<APIError?>()
        return Input(
            viewDidLoad: viewDidLoad,
            loadingSubject: loadingSubject,
            contentSubject: contentSubject,
            errorSubject: errorSubject
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

    let user: User
    let isFollowers: Bool

    // MARK: Private

    private let disposeBag = DisposeBag()
    private let githubService: GitHubService

    // MARK: - Bindings

    private func bindOnViewDidLoad() {
        input
            .viewDidLoad
            .observe(on: MainScheduler.instance)
            .do(onNext: { [unowned self] _ in
                self.input.loadingSubject.onNext(true)
                self.makeAPICall()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func makeAPICall() {
        var observerble: Single<[User]>
        switch isFollowers {
        case true:
            observerble = githubService.followers(user: user.login)
        case false:
            observerble = githubService.following(user: user.login)
        }
        if !UIApplication.shared.isRunningTestCases {
            observerble = observerble.observe(on: MainScheduler.instance)
        }
        observerble
            .subscribe(
                onSuccess: { [weak self] in
                    guard let self = self else { return }
                    self.input.contentSubject.onNext($0)
                    self.input.loadingSubject.onNext(false)
                },
                onFailure: { [weak self] in
                    guard let self = self else { return }
                    self.input.errorSubject.onNext(APIError.underlyingError($0))
                    self.input.loadingSubject.onNext(false)
                }
            ).disposed(by: disposeBag)
    }
}
