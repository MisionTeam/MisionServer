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
import PerfectLogger

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
        guard let facebook_token = request.param(name: "fb_token"), !facebook_token.isEmpty else {
            
            response.missing(field: "fb_token")
            return
        }
        
        func loginWith(token: String) {
            let body: [String: Any] = ["token": token.encodedToken!]
            
            // TODO: create session
            response.sendJSONBodyWithSuccess(json: body)
            
            LogFile.info("Login success!")
        }
        
        FacebookGraph.verifyUser(facebook_token: facebook_token) { (fbUserID, error) in
            if let fb_user_id = fbUserID {
                
                if let user = UserFactory.findUserBy(facebookID: fb_user_id) {
                    
                    let tokenString = "mision,\(user._id),\(Date().description)"
                    
                    loginWith(token: tokenString)
                    
                } else {
                    
                    FacebookGraph.fetchUserProfile(access_token: facebook_token) { (profile, error) in
                        guard let profile = profile, error == nil else {
                            response.accessDenied()
                            return
                        }
                        
                        do {
                            if let user = try UserFactory.create(userInfo: profile) {
                                let tokenString = "mision,\(user._id),\(Date().description)"
                                
                                loginWith(token: tokenString)
                            }
                        } catch {
                            response.internalError()
                        }
                    }
                }
            } else {
                response.accessDenied()
            }
        }
    }
    
    func logoutHandler(request: HTTPRequest, response: HTTPResponse) {
        response.sendJSONBodyWithSuccess(json: nil)
    }
}
