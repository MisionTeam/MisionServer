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
        routes.add(method: AuthEndpoint.fbLogin.method, uri: AuthEndpoint.fbLogin.uri, handler: fbLoginHandler)
        routes.add(method: AuthEndpoint.profileFull.method, uri: AuthEndpoint.profileFull.uri, handler: profileGetHandler)
        routes.add(method: AuthEndpoint.updateProfile.method, uri: AuthEndpoint.updateProfile.uri, handler: profilePostHandler)
        routes.add(method: AuthEndpoint.logout.method, uri: AuthEndpoint.logout.uri, handler: logoutHandler)
    }
    
    
    func fbLoginHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let fbToken = request.param(name: "fb_token"), !fbToken.isEmpty else {
            
            response.accessDenied()
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
            
            response.accessDenied()
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
