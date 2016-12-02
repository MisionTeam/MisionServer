//
//  RoutingAuth.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectLib
import PerfectHTTP
import TurnstileCrypto

struct RoutingAuth: RoutesBuilder {
    
    var routes: Routes
    
    init() {
        routes = Routes(baseUri: AuthEndpoint.base)
        
        buildRoutes()
    }
    
    mutating func buildRoutes() {
        routes.add(method: AuthEndpoint.fbLogin.method, uri: AuthEndpoint.fbLogin.uri, handler: fbLoginHandler)
        routes.add(method: AuthEndpoint.logout.method, uri: AuthEndpoint.logout.uri, handler: logoutHandler)
    }
    
    
    func fbLoginHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let fbToken = request.param(name: "fb_token"), !fbToken.isEmpty else {
            
            response.missing(field: "fb_token")
            return
        }
        
        // TODO: check with fb
        
        let token = URandom().secureToken
        let body: [String: Any] = ["token": token]
    
        response.sendJSONBodyWithSuccess(json: body)
    }
    
    func logoutHandler(request: HTTPRequest, response: HTTPResponse) {
        response.sendJSONBodyWithSuccess(json: nil)
    }
}
