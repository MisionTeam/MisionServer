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
        
        var token: String?
        
        for (key, value) in queryParams {
            if key == "token" {
                token = value
                break
            }
        }
        
        return token
    }
}
