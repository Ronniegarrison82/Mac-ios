import Foundation

struct ProjectOrganizer {
    let fileManager = FileManager.default
    let basePath: URL

    func organize() {
        let folders = ["Modules", "Database", "Resources"]
        for folder in folders {
            let folderPath = basePath.appendingPathComponent(folder)
            if !fileManager.fileExists(atPath: folderPath.path) {
                try? fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true)
            }
        }

        let files = try? fileManager.contentsOfDirectory(atPath: basePath.path)
        files?.forEach { file in
            let fullPath = basePath.appendingPathComponent(file)
            if file.hasSuffix(".swift") {
                move(fullPath, to: "Modules")
            } else if file.hasSuffix(".json") || file.hasSuffix(".sqlite") {
                move(fullPath, to: "Database")
            } else if file.hasSuffix(".png") || file.hasSuffix(".xib") {
                move(fullPath, to: "Resources")
            }
        }
    }

    private func move(_ file: URL, to folder: String) {
        let dest = basePath.appendingPathComponent(folder).appendingPathComponent(file.lastPathComponent)
        try? fileManager.moveItem(at: file, to: dest)
    }
}