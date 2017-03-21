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
        
                let body: [String: Any]
                
                if let user = UserFactory.findUserBy(facebookID: fbToken) {
                    
                    let tokenString = "mision,\(user.id),\(Date().description)"
                    
                    body = ["token": tokenString.encodedToken!,
                            "is_new_user": false]
                    
                    // TODO: create session
                    
                } else {
                    body = ["is_new_user": true]
                }
                
                response.sendJSONBodyWithSuccess(json: body)
            }
            
            response.accessDenied()
        }
    }
    
    func logoutHandler(request: HTTPRequest, response: HTTPResponse) {
        response.sendJSONBodyWithSuccess(json: nil)
    }
}
