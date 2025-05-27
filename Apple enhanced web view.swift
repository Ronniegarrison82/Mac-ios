// Main interface to import for your app

import Foundation

public struct AppleIntelligentInterface {
    public static func platformName() -> String {
        return PlatformUtilities.deviceName
    }
    
    public static func open(url: URL) {
        PlatformUtilities.openURL(url)
    }
    
    public static func analyzeSentiment(text: String) -> String {
        return AIExtensions.sentimentAnalysis(for: text)
    }
    
    // Extend with more intelligent interface features here
}