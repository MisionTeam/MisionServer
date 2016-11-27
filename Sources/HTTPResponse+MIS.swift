//
//  Extension.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectHTTP

enum Status: Int {
    case success        = 200
    
    case accessDenied   = 401,
         missingField   = 403
}

extension HTTPResponse {
    func defaultHeader() {
        self.setHeader(.accessControlAllowOrigin, value: "*")
        self.setHeader(.contentType, value: ContentType.json.rawValue)
    }
    
    func defaultBody() {
        self.setBody(string: "From Mision Server")
    }
    
    func sendJSONBody(json: [String: Any]) {
        self.defaultHeader()
        
        do {
            try self.setBody(json: json)
        } catch {
            self.setBody(string: "Internal Error!")
        }
        
        defer {
            self.completed()
        }
    }
    
    func accessDenied() {
        
        let body: [String: Any] = ["success": false, "status": Status.accessDenied, "error": "Access denied or bad access token"]
        
        self.sendJSONBody(json: body)
    }
    
    func missing(field: String) {
        
        let body: [String: Any] = ["success": false, "status": Status.missingField, "error": "Access denied or bad access token"]
        
        self.sendJSONBody(json: body)
    }
}
