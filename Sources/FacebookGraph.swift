//
//  FacebookGraph.swift
//  MisionServer
//
//  Created by Tao on 2017-03-05.
//
//

import Foundation

typealias UserHandler = (String?, Error?) -> Void

struct FacebookGraph {
    
    enum ReturnError: Error {
        case parsing
        case invalid
    }
    
    struct Console {
        static let debug_URL = "https://graph.facebook.com/debug_token?%@=%@&%@=%@"
        
        static let app_token = "899888736779528%7Clz8uz_Y_fybXNVE0PesGVygxTsA"
        
        static let input_token_key = "input_token"
        
        static let access_token_key = "access_token"
    }
    
    static func verifyUser(token: String, completion: @escaping UserHandler) {
        
        let urlString = String(format: Console.debug_URL, Console.input_token_key, token, Console.access_token_key, Console.app_token)
        
        var request = URLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        
                        if let userID = (jsonObject["data"] as? [String: Any])?["user_id"] as? String {
                            completion(userID, nil)
                        } else {
                            completion(nil, ReturnError.invalid)
                        }
                        
                    } else {
                        completion(nil, ReturnError.parsing)
                    }
                    
                } catch {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
