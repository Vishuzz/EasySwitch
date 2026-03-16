import Foundation
import UIKit

class FileConverterService {
    
    private let uploadManager = UploadManager()
    private let pdfService = PDFService()
    
    func convert(document: DocumentFile, completion: @escaping (URL?) -> Void) {
        
        switch document.conversionType {
            
        case .imageToPDF:
            if let image = UIImage(contentsOfFile: document.fileURL.path) {
                let result = pdfService.createPDF(from: image)
                completion(result)
            } else {
                completion(nil)
            }
            
        case .textToPDF:
            if let text = try? String(contentsOf: document.fileURL) {
                let result = pdfService.createPDF(from: text)
                completion(result)
            } else {
                completion(nil)
            }
            
        default:
            uploadManager.uploadFile(fileURL: document.fileURL) { url in
                completion(url)
            }
        }
    }
}
