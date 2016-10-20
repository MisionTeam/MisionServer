//
//  Authentication.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectLib
import PerfectHTTP

struct AuthRouting {
    
    var routes: Routes
    
    init() {
        routes = Routes(baseUri: AuthEndpoint.base)
        
        buildRoutes()
    }
    
    mutating func buildRoutes() {
        routes.add(method: .post, uri: AuthEndpoint.login.rawValue, handler: loginHandler)
        routes.add(method: .get, uri: AuthEndpoint.profile.rawValue, handler: profileGetHandler)
        routes.add(method: .post, uri: AuthEndpoint.profile.rawValue, handler: profilePostHandler)
        routes.add(method: .delete, uri: AuthEndpoint.logout.rawValue, handler: logoutHandler)
    }
    
    
    func loginHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let fbToken = request.param(name: "fb_token"), !fbToken.isEmpty else {
            
            ErrorResponse.accessDenied(response: response)
            return
        }
        
        // TODO: check with fb
        // TODO: generate server token
        
        let token = UUID().string
        let body: [String: Any] = ["success": true, "statusCode": 200, "token": token]
    
        response.sendJSONBody(json: body)
    }
    
    func profileGetHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let token = request.param(name: "token"), !token.isEmpty else {
            
            ErrorResponse.accessDenied(response: response)
            return
        }
        
        let name: [String: String] = ["firstName": "Tommy", "lastName": "Hardy"]
        let body: [String: Any] = ["member": name]
        
        response.defaultHeader()
        response.sendJSONBody(json: body)
    }
    
    func profilePostHandler(request: HTTPRequest, response: HTTPResponse) {
        response.defaultHeader()
        response.defaultBody()
        response.completed()
    }
    
    func logoutHandler(request: HTTPRequest, response: HTTPResponse) {
        response.defaultHeader()
        response.defaultBody()
        response.completed()
    }
}
