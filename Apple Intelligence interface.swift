import Foundation
import UIKit

// MARK: - AppleIntelligentInterface

public struct AppleIntelligentInterface {
    
    /// Returns the current platform/device name.
    public static var platformName: String {
        return PlatformUtilities.deviceName
    }
    
    /// Opens a URL safely, checking if it can be opened.
    /// - Parameter url: The URL to open.
    public static func open(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            print("Invalid or unsupported URL: \(url.absoluteString)")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    /// Analyzes the sentiment of the given text.
    /// - Parameter text: Input text to analyze.
    /// - Returns: A string describing sentiment (e.g., "Positive", "Neutral", "Negative").
    public static func analyzeSentiment(text: String) -> String {
        return AIExtensions.sentimentAnalysis(for: text)
    }
    
    /// Detects language of a given text input.
    /// - Parameter text: Input text.
    /// - Returns: Detected language code or name.
    public static func detectLanguage(of text: String) -> String {
        return AIExtensions.languageDetection(for: text)
    }
    
    /// Translates text to a target language.
    /// - Parameters:
    ///   - text: Input text.
    ///   - targetLanguage: Target language code (e.g., "es", "fr").
    /// - Returns: Translated text.
    public static func translate(text: String, to targetLanguage: String) -> String {
        return AIExtensions.translate(text: text, to: targetLanguage)
    }
    
    // Add more AI-based tools, like summarization, classification, etc.
}