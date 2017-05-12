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
import MSDataModel

public struct RoutingAuth: RoutesBuilder {
    
    public var routes: Routes
    
    public init() {
        routes = Routes(baseUri: AuthEndpoint.baseURL)
        
        buildRoutes()
    }
    
    mutating func buildRoutes() {
        routes.add(method: AuthEndpoint.fbLogin.method, uri: AuthEndpoint.fbLogin.route, handler: fbLoginHandler)
        routes.add(method: AuthEndpoint.logout.method, uri: AuthEndpoint.logout.route, handler: logoutHandler)
    }
    
    
    func fbLoginHandler(request: HTTPRequest, response: HTTPResponse) {
        
        LogFile.info("User logging in")
        
        guard let facebook_token = request.param(name: "fb_token"), !facebook_token.isEmpty else {
            
            response.missing(field: "fb_token")
            return
        }
        
        func loginWith(userID: String) {
            let body: [String: Any] = ["token": userID.toToken!]
            
            // TODO: create session
            response.sendJSONBodyWithSuccess(json: body)
            
            LogFile.info("Login success!")
        }
        
        FacebookGraph.verifyUser(facebook_token: facebook_token) { (fbUserID, error) in
            
            LogFile.info("facebook verified, error:\(error?.localizedDescription ?? "")")
            
            guard let fb_user_id = fbUserID else {
                response.accessDenied()
                return
            }
            
            if let user = UserFactory.findUserBy(facebookID: fb_user_id) {
                
                loginWith(userID: user.identifier)
                
            } else {
                
                FacebookGraph.fetchUserProfile(access_token: facebook_token) { (profile, error) in
                    
                    LogFile.info("fb profile fetched, error: \(error?.localizedDescription ?? "")")
                    
                    guard let profile = profile, error == nil else {
                        response.accessDenied()
                        return
                    }
                    
                    guard let user = UserFactory.create(userInfo: profile) else{
                        response.internalError()
                        return
                    }
                    
                    loginWith(userID: user.identifier)
                }
            }
        }
    }
    
    func logoutHandler(request: HTTPRequest, response: HTTPResponse) {
        response.sendJSONBodyWithSuccess(json: nil)
    }
}
