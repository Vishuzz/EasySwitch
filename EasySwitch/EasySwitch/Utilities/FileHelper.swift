import Foundation

struct FileHelper {
    
    static func getFileName(from url: URL) -> String {
        return url.lastPathComponent
    }
    
    static func getFileExtension(from url: URL) -> String {
        return url.pathExtension
    }
    
    static func temporaryFileURL(fileName: String) -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        return tempDirectory.appendingPathComponent(fileName)
    }
}
