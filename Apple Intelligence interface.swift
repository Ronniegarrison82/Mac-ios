import Foundation
import UIKit

// MARK: - Protocols

public protocol PlatformInfoProviding {
var platformName: String { get }
}

public protocol URLOpener {
func open(url: URL)
}

public protocol SentimentAnalyzing {
func analyze(text: String) -> String
}

public protocol LanguageDetecting {
func detectLanguage(of text: String) -> String
}

public protocol Translating {
func translate(text: String, to targetLanguage: String) -> String
}

// MARK: - Default Implementations

public class DefaultPlatformProvider: PlatformInfoProviding {
public var platformName: String {
return PlatformUtilities.deviceName
}
}

public class DefaultURLOpener: URLOpener {
public func open(url: URL) {
guard UIApplication.shared.canOpenURL(url) else {
print("Invalid or unsupported URL: \(url.absoluteString)")
return
}
UIApplication.shared.open(url, options: [:], completionHandler: nil)
}
}

public class DefaultSentimentAnalyzer: SentimentAnalyzing {
public func analyze(text: String) -> String {
return AIExtensions.sentimentAnalysis(for: text)
}
}

public class DefaultLanguageDetector: LanguageDetecting {
public func detectLanguage(of text: String) -> String {
return AIExtensions.languageDetection(for: text)
}
}

public class DefaultTranslator: Translating {
public func translate(text: String, to targetLanguage: String) -> String {
return AIExtensions.translate(text: text, to: targetLanguage)
}
}

// MARK: - AppleIntelligentInterface

public struct AppleIntelligentInterface {
private let platformProvider: PlatformInfoProviding
private let urlOpener: URLOpener
private let sentimentAnalyzer: SentimentAnalyzing
private let languageDetector: LanguageDetecting
private let translator: Translating

public init(
platformProvider: PlatformInfoProviding = DefaultPlatformProvider(),
urlOpener: URLOpener = DefaultURLOpener(),
sentimentAnalyzer: SentimentAnalyzing = DefaultSentimentAnalyzer(),
languageDetector: LanguageDetecting = DefaultLanguageDetector(),
translator: Translating = DefaultTranslator()
) {
self.platformProvider = platformProvider
self.urlOpener = urlOpener
self.sentimentAnalyzer = sentimentAnalyzer
self.languageDetector = languageDetector
self.translator = translator
}

public var platformName: String {
return platformProvider.platformName
}

public func open(url: URL) {
urlOpener.open(url: url)
}

public func analyzeSentiment(text: String) -> String {
return sentimentAnalyzer.analyze(text: text)
}
