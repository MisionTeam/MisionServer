//
//  HTTPRequest+MIS.swift
//  MisionServer
//
//  Created by Tao on 2017-03-05.
//
//

import PerfectHTTP

extension HTTPRequest {
    
    var token: String? {
        
        guard let token = header(.authorization), !token.isEmpty else {
            return nil
        }
        
        return token
    }
}
