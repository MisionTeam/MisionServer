//
//  FacebookGraph.swift
//  MisionServer
//
//  Created by Tao on 2017-03-05.
//
//

import PerfectCURL

typealias UserHandler = (String?, Error?) -> Void
typealias ProfileHandler = ([String: Any]?, Error?) -> Void

struct FacebookGraph {
    
    enum ReturnError: Error {
        case parsing
        case invalid
        case expired
    }
    
    struct Console {
        static let debug_URL = "https://graph.facebook.com/debug_token?"
        static let graph_URL = "https://graph.facebook.com/v2.8/me?fields=email,last_name,first_name,gender,birthday,picture.type(large)&access_token="
        
        static let app_token = "899888736779528%7Clz8uz_Y_fybXNVE0PesGVygxTsA"
        
        static let input_token_key = "input_token"
        
        static let access_token_key = "access_token"
    }
    
    static func verifyUser(facebook_token: String, completion: @escaping UserHandler) {
        
        let urlString = "\(Console.debug_URL)\(Console.input_token_key)=\(facebook_token)&\(Console.access_token_key)=\(Console.app_token)"
        
        let curlObject = CURL(url: urlString)
        
        curlObject.perform { (code, header, body) in
            let bodyString = String(bytes: body, encoding: .utf8)
            
            if let jsonObject = (try? bodyString?.jsonDecode()) as? [String: Any] {
                
                if let userID = (jsonObject["data"] as? [String: Any])?["user_id"] as? String {
                    
                    completion(userID, nil)
                    
                    return
                }
                
                completion(nil, ReturnError.invalid)
                
                return
            }
            
            completion(nil, ReturnError.parsing)
            
            return
        }
    }
    
    static func fetchUserProfile(access_token: String, completion: @escaping ProfileHandler) {
        
        let urlString = "\(Console.graph_URL)\(access_token)"
        
        let curlObject = CURL(url: urlString)
        
        curlObject.perform { (code, header, body) in
            let bodyString = String(bytes: body, encoding: .utf8)
            
            if let jsonObject = (try? bodyString?.jsonDecode()) as? [String: Any] {
                
                if let _ = jsonObject["error"] {
                    
                    completion(nil, ReturnError.expired)
                    
                    return
                }
                
                completion(jsonObject, nil)
                return
            }
            
            completion(nil, ReturnError.parsing)
            
            return
        }
    }
}
