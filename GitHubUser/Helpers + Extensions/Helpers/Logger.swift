//
//  Logger.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import os
import Logging
import Foundation

let log: Logging.Logger = {
    let osLogHandler = OSLogHandler()
    let multiplexLogHandler = MultiplexLogHandler([osLogHandler])
    return Logger(label: Bundle.main.bundleIdentifier!, factory: { _ in multiplexLogHandler })
}()

private final class OSLogHandler: LogHandler {
    var metadata = Logger.Metadata()
    var logLevel = Logger.Level.debug

    private let osLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "data")

    subscript(metadataKey metadataKey: String) -> Logging.Logger.Metadata.Value? {
        get { metadata[metadataKey] }
        set(newValue) { metadata[metadataKey] = newValue }
    }

    func log(
        level: Logging.Logger.Level,
        message: Logging.Logger.Message,
        metadata: Logging.Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let (emojiLevel, osLogType): (String, OSLogType) = {
            switch level {
            case .trace: return ("🖤", .debug)
            case .debug: return ("💚", .debug)
            case .info: return ("💙", .info)
            case .notice: return ("💜", .default)
            case .warning: return ("💛", .default)
            case .error: return ("❤️", .error)
            case .critical: return ("💔", .fault)
            }
        }()

        let filename = URL(fileURLWithPath: file).lastPathComponent
        let detailsString = metadata.map {
            return "\n" + $0.map { pair in
                "\(pair.key): \(pair.value)"
            }
            .joined(separator: "\n")
        }

        os_log(
            "%@ [%@:%d] %{public}@%@",
            log: osLog,
            type: osLogType,
            emojiLevel,
            filename,
            line,
            message.description,
            detailsString ?? ""
        )
    }
}

