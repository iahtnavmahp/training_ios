//
//  APIManager.swift
//  training_ios
//
//  Created by Pham Van Thai on 16/03/2022.
//

import Foundation

typealias JSON = [String: Any]
typealias JSON2 = [Any]
extension Data {
    func toJSON() -> JSON {
        var json: [String:Any] = [:]
        do {
            if let jsonObj = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? JSON {
                json = jsonObj
            }
        } catch {
            print("JSON casting error")
        }
        return json
    }
    func toJSON2() -> JSON2 {
        var json: [Any] = []
        do {
            if let jsonObj = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? JSON2 {
                json = jsonObj
            }
        } catch {
            print("JSON casting error")
        }
        return json
    }
}
enum APIError: Error {
    case error(String)
    case errorURL
    
    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
        }
    }
}

typealias APICompletion<T> = (Result<T, APIError>) -> Void

enum APIResult {
    case success(Data?)
    case failure(APIError)
}

struct APIManager {
    
    private static var shareAPI: APIManager = {
        let shareAPI = APIManager()
        return shareAPI
    }()
    
    static func shared() -> APIManager {
        return shareAPI
    }
    
    
    private init() {}
    
    func request(urlString: String, completion: @escaping (APIResult) -> Void) {
     
                guard let url = URL(string: urlString) else {
                    return
                }
                var testRequest = URLRequest(url: url)
                testRequest.httpMethod = "GET"
                let config = URLSessionConfiguration.ephemeral
                config.waitsForConnectivity = true
                let session = URLSession.shared
                let dataTask = session.dataTask(with: testRequest) { (data, _, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.failure(.error(error.localizedDescription)))
                        } else {
                            if let data = data {
                                completion(.success(data))
                            }
                        }
                    }
                }
                dataTask.resume()
    }
}
