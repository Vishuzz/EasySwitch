import Foundation

struct DocumentFile: Identifiable {
    let id = UUID()
    let fileName: String
    let fileURL: URL
    let conversionType: ConversionType
}
