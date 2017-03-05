//
//  ContentType.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectHTTP
import Foundation

enum ContentType: String {
    case json   = "application/json"
    case html   = "text/html"
}

extension String {
    
    var encodedToken: String? {
        return self.data(using: .utf8)?.base64EncodedString()
    }
    
    var decodedString: String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
