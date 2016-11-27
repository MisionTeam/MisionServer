//
//  Authentication.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectLib
import PerfectHTTP
import TurnstileCrypto

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
            
            response.missing(field: "fb_token")
            return
        }
        
        // TODO: check with fb
        
        let token = URandom().secureToken
        let body: [String: Any] = ["token": token]
    
        response.sendJSONBodyWithSuccess(json: body)
    }
    
    func profileGetHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let token = request.param(name: "token"), !token.isEmpty else {
            
            response.accessDenied()
            return
        }
        
        if let localProfile = loadLocalProfile() {
            response.sendJSONBodyWithSuccess(json: localProfile)
        } else {
            response.notFound()
        }
    }
    
    func profilePostHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let token = request.param(name: "token"), !token.isEmpty else {
            
            response.accessDenied()
            return
        }
        
        guard let profileString = request.param(name: "user") else {
            response.missing(field: "user")
            return
        }
        
        guard let profile = (try? profileString.jsonDecode()) as? [String: Any] else {
            response.decodeError()
            return
        }
        
        let validation = check(profile: profile)
        
        if validation.valid {
            response.sendJSONBodyWithSuccess(json: nil)
        } else {
            response.missing(field: validation.missing)
        }
    }
    
    func logoutHandler(request: HTTPRequest, response: HTTPResponse) {
        response.sendJSONBodyWithSuccess(json: nil)
    }
    
    private func loadLocalProfile() -> [String: Any]? {
        let profileFile = File("./webroot/profile_full.json")
        
        if let jsonString = try? profileFile.readString() {
            if let decoded = (try? jsonString.jsonDecode()) as? [String: Any] {
                return decoded
            }
        }
        
        return nil
    }
    
    private func check(profile: [String: Any]) -> (valid: Bool, missing: String) {
        
        struct Required {
            static let gender = "gender"
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let age = "age"
            static let email = "email"
        }
        
        guard let _ = profile[Required.gender] else {
            return (false, Required.gender)
        }
        
        guard let _ = profile[Required.firstName] else {
            return (false, Required.firstName)
        }
        
        guard let _ = profile[Required.lastName] else {
            return (false, Required.lastName)
        }
        
        guard let _ = profile[Required.age] else {
            return (false, Required.age)
        }
        
        guard let _ = profile[Required.email] else {
            return (false, Required.email)
        }
        
        return (true, "")
    }
}
