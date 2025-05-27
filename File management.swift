import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

struct FileManagement {
    
    static func getDocumentsDirectory() -> URL {
        #if os(macOS)
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        #elseif os(iOS)
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        #endif
    }
    
    static func saveTextFile(named fileName: String, content: String) throws {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
    }
    
    static func loadTextFile(named fileName: String) throws -> String {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        return try String(contentsOf: fileURL)
    }
}