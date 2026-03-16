import Foundation

enum ConversionType: String, CaseIterable, Identifiable {
    case pdfToWord = "PDF to Word"
    case wordToPDF = "Word to PDF"
    case imageToPDF = "Image to PDF"
    case pdfToImage = "PDF to Image"
    case textToPDF = "Text to PDF"
    case pdfToText = "PDF to Text"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .pdfToWord:
            return "doc.text"
        case .wordToPDF:
            return "doc.richtext"
        case .imageToPDF:
            return "photo"
        case .pdfToImage:
            return "photo.on.rectangle"
        case .textToPDF:
            return "text.alignleft"
        case .pdfToText:
            return "doc.plaintext"
        }
    }
}
