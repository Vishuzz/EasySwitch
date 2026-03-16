import Foundation
import UIKit
import PDFKit

class PDFService {
    
    func createPDF(from image: UIImage) -> URL? {
        
        let pdfMetaData = [
            kCGPDFContextCreator: "EasySwitch",
            kCGPDFContextAuthor: "Vishek"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            image.draw(in: pageRect)
        }
        
        let url = FileHelper.temporaryFileURL(fileName: "image_to_pdf.pdf")
        
        do {
            try data.write(to: url)
            return url
        } catch {
            return nil
        }
    }
    
    func createPDF(from text: String) -> URL? {
        
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18)
            ]
            
            text.draw(in: CGRect(x: 20, y: 20, width: 550, height: 800), withAttributes: attributes)
        }
        
        let url = FileHelper.temporaryFileURL(fileName: "text_to_pdf.pdf")
        
        do {
            try data.write(to: url)
            return url
        } catch {
            return nil
        }
    }
}
