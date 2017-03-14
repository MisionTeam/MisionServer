//
//  RoutingAuth.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectLib
import PerfectHTTP
import Foundation

struct RoutingAuth: RoutesBuilder {
    
    var routes: Routes
    
    init() {
        routes = Routes(baseUri: AuthEndpoint.baseURL)
        
        buildRoutes()
    }
    
    mutating func buildRoutes() {
        routes.add(method: AuthEndpoint.fbLogin.method, uri: AuthEndpoint.fbLogin.route, handler: fbLoginHandler)
        routes.add(method: AuthEndpoint.logout.method, uri: AuthEndpoint.logout.route, handler: logoutHandler)
    }
    
    
    func fbLoginHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let fbToken = request.param(name: "fb_token"), !fbToken.isEmpty else {
            
            response.missing(field: "fb_token")
            return
        }
        
        FacebookGraph.verifyUser(token: fbToken) { (fbUserID, error) in
            if let fb_user_id = fbUserID {
                
                // TODO: check out mision user id
                
                let tokenString = "mision,\(Date().description)"
                
                let body: [String: Any] = ["token": tokenString.encodedToken!]
                
                response.sendJSONBodyWithSuccess(json: body)
            }
            
            response.accessDenied()
        }
    }
    
    func logoutHandler(request: HTTPRequest, response: HTTPResponse) {
        response.sendJSONBodyWithSuccess(json: nil)
    }
}
