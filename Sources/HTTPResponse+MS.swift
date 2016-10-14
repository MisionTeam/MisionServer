//
//  Extension.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectHTTP

extension HTTPResponse {
    func defaultHeader() {
        let request = self.request.uri
        self.setHeader(.accessControlAllowOrigin, value: request)
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
}