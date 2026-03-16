import Foundation

class UploadManager {
    
    func uploadFile(fileURL: URL, completion: @escaping (URL?) -> Void) {
        
        guard let url = APIManager.convertURL else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        let fileData = try? Data(contentsOf: fileURL)
        let fileName = fileURL.lastPathComponent
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
        data.append(fileData ?? Data())
        data.append("\r\n".data(using: .utf8)!)
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        URLSession.shared.uploadTask(with: request, from: data) { responseData, _, _ in
            
            guard let responseData = responseData else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let tempURL = FileHelper.temporaryFileURL(fileName: "converted_file.pdf")
            
            do {
                try responseData.write(to: tempURL)
                
                DispatchQueue.main.async {
                    completion(tempURL)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
        }.resume()
    }
}
