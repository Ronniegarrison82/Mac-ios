import Foundation
import UIKit

// MARK: - Errors

public enum AIError: Error, LocalizedError {
case analysisFailed
case languageDetectionFailed
case translationFailed
case invalidURL(URL)

public var errorDescription: String? {
switch self {
case .analysisFailed: return "Sentiment analysis failed."
case .languageDetectionFailed: return "Language detection failed."
case .translationFailed: return "Translation failed."
case .invalidURL(let url): return "Invalid or unsupported URL: \(url.absoluteString)"
}
}
}

// MARK: - Protocols

public protocol PlatformInfoProviding {
var platformName: String { get }
}

public protocol URLOpener {
/// Attempts to open the provided URL asynchronously.
/// Throws if the URL is invalid or unsupported.
func open(url: URL) async throws
}

public protocol SentimentAnalyzing {
/// Analyzes the sentiment of the given text asynchronously.
/// Returns a sentiment string or throws on failure.
func analyze(text: String) async throws -> String
}

public protocol LanguageDetecting {
/// Detects the language of the provided text asynchronously.
/// Returns the language code or throws on failure.
func detectLanguage(of text: String) async throws -> String
}

public protocol Translating {
/// Translates the provided text to the target language asynchronously.
/// Returns the translated text or throws on failure.
func translate(text: String, to targetLanguage: String) async throws -> String
}

// MARK: - Default Implementations

public final class DefaultPlatformProvider: PlatformInfoProviding {
public var platformName: String {
PlatformUtilities.deviceName
}
}

@MainActor
public final class DefaultURLOpener: URLOpener {
public init() {}

public func open(url: URL) async throws {
guard UIApplication.shared.canOpenURL(url) else {
throw AIError.invalidURL(url)
}
UIApplication.shared.open(url, options: [:], completionHandler: nil)
}
}

public final class DefaultSentimentAnalyzer: SentimentAnalyzing {
public init() {}

public func analyze(text: String) async throws -> String {
let result = AIExtensions.sentimentAnalysis(for: text)
guard !result.isEmpty else {
throw AIError.analysisFailed
}
return result
}
}

public final class DefaultLanguageDetector: LanguageDetecting {
public init() {}

public func detectLanguage(of text: String) async throws -> String {
let language = AIExtensions.languageDetection(for: text)
guard !language.isEmpty else {
throw AIError.languageDetectionFailed
}
return language
}
}

public final class DefaultTranslator: Translating {
public init() {}

public func translate(text: String, to targetLanguage: String) async throws -> String {
let translation = AIExtensions.translate(text: text, to: targetLanguage)
guard !translation.isEmpty else {
throw AIError.translationFailed
}
return translation
}
}
