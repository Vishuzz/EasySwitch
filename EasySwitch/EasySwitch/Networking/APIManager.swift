import Foundation

struct APIManager {
    
    static var convertURL: URL? {
        URL(string: Constants.baseURL + Constants.convertEndpoint)
    }
}
