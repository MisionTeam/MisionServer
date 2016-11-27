//
//  Extension.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectHTTP

enum Status: Int, CustomStringConvertible {
    
    case success        = 200
    
    case decodeError    = 400,
         accessDenied   = 401,
         missingField   = 403,
         notFound       = 404,
         internalError  = 500
    
    var description: String {
        switch self {
        case .success: return "Success"
        case .decodeError: return "JSON format error"
        case .accessDenied: return "Access denied or bad access token"
        case .missingField: return "Missing field"
        case .notFound : return "Target file not found"
        case .internalError: return "Internal Error"
        }
    }
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
            self.setBody(string: Status.internalError.description)
        }
        
        defer {
            self.completed()
        }
    }
    
    func sendJSONBodyWithSuccess(json: [String: Any]?) {
        var success: [String: Any] = ["success": true, "status": 200]
        
        if let body = json {
            for (k, v) in body {
                success[k] = v
            }
        }
        
        sendJSONBody(json: success)
    }
    
    func accessDenied() {
        
        sendJSONBody(json: generateErrorWith(status: .accessDenied))
    }
    
    func missing(field: String) {
        
        let body: [String: Any] = ["success": false, "status": Status.missingField.rawValue, "error": Status.missingField.description + " (\"\(field)\")"]
        
        sendJSONBody(json: body)
    }
    
    func notFound() {
        
        sendJSONBody(json: generateErrorWith(status: .notFound))
    }
    
    func decodeError() {
        sendJSONBody(json: generateErrorWith(status: .decodeError))
    }
    
    private func generateErrorWith(status: Status) -> [String: Any] {
        return ["success": false, "status": status.rawValue, "error": status.description]
    }
}
