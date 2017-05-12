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
    
    var toToken: String? {
        
        let tokenString = "mision,\(self),\(Date().description)"
        
        return tokenString.data(using: .utf8)?.base64EncodedString()
    }
    
    var toUserID: String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        guard let tokenString = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        let tokenComponents = tokenString.components(separatedBy: ",")
        
        guard tokenComponents.count > 2 else {
            return nil
        }
        
        guard tokenComponents.first == "mision" else {
            return nil
        }
        
        return tokenComponents[1]
    }
    
    var toInt: Int? {
        return Int(self)
    }
    
    var toBool: Bool? {
        switch self {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    var toDouble: Double? {
        return Double(self)
    }
}
