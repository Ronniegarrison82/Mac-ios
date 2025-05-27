import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

struct PlatformUtilities {
    
    static func openURL(_ url: URL) {
        #if os(macOS)
        NSWorkspace.shared.open(url)
        #elseif os(iOS)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        #endif
    }
    
    static var deviceName: String {
        #if os(macOS)
        return Host.current().localizedName ?? "macOS Device"
        #elseif os(iOS)
        return UIDevice.current.name
        #endif
    }
    
    static func isDesktopLike() -> Bool {
        #if targetEnvironment(macCatalyst) || os(macOS)
        return true
        #else
        return false
        #endif
    }
}