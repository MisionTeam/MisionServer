//
//  Extension.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectHTTP

struct ErrorResponse {
    static func accessDenied(response: HTTPResponse) {
        
        let body: [String: Any] = ["success": false, "statusCode": 401, "errorMessage": "Access denied or bad access token"]
        
        response.sendJSONBody(json: body)
    }
}
