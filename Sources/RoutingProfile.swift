//
//  RoutingProfile.swift
//  MisionServer
//
//  Created by Tao on 2016-12-02.
//
//

import PerfectLib
import PerfectHTTP
import TurnstileCrypto

struct RoutingProfile: RoutesBuilder {
    
    var routes: Routes
    
    init() {
        routes = Routes(baseUri: ProfileEndpoint.base)
        
        buildRoutes()
    }
    
    mutating func buildRoutes() {
        routes.add(method: ProfileEndpoint.profileFull.method, uri: ProfileEndpoint.profileFull.uri, handler: getProfileHandler)
        routes.add(method: ProfileEndpoint.profileBasic.method, uri: ProfileEndpoint.profileBasic.uri, handler: getBasicProfileHandler)
        routes.add(method: ProfileEndpoint.profilePreview.method, uri: ProfileEndpoint.profilePreview.uri, handler: getPreviewProfileHandler)
        routes.add(method: ProfileEndpoint.profileLabels.method, uri: ProfileEndpoint.profileLabels.uri, handler: getMyLabelsHandler)
        routes.add(method: ProfileEndpoint.updateProfile.method, uri: ProfileEndpoint.updateProfile.uri, handler: profilePostHandler)
    }
    
    
    func getProfileHandler(request: HTTPRequest, response: HTTPResponse) {
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
    
    func getBasicProfileHandler(request: HTTPRequest, response: HTTPResponse) {
        
        guard let token = request.param(name: "token"), !token.isEmpty else {
            
            response.accessDenied()
            return
        }
        
        struct BasicFields {
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let email = "email"
        }
        
        if let localProfile = loadLocalProfile()?["user"] as? [String: Any] {
            
            var basicProfile = [String: Any]()
                
            for (k, v) in localProfile {
                if k == BasicFields.firstName || k == BasicFields.lastName || k == BasicFields.email {
                    basicProfile[k] = v
                }
            }
            
            response.sendJSONBodyWithSuccess(json: basicProfile)
        } else {
            response.notFound()
        }
    }
    
    func getPreviewProfileHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let token = request.param(name: "token"), !token.isEmpty else {
            
            response.accessDenied()
            return
        }
        
        struct PreviewFields {
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let email = "email"
        }
        
        if let localProfile = loadLocalProfile()?["user"] as? [String: Any] {
            
            var previewProfile = [String: Any]()
            
            for (k, v) in localProfile {
                if k == PreviewFields.firstName || k == PreviewFields.lastName || k == PreviewFields.email {
                    previewProfile[k] = v
                }
            }
            
            response.sendJSONBodyWithSuccess(json: previewProfile)
        } else {
            response.notFound()
        }
    }
    
    func getMyLabelsHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let token = request.param(name: "token"), !token.isEmpty else {
            
            response.accessDenied()
            return
        }
        
        if let localProfile = loadLocalProfile()?["user"] as? [String: Any] {
            
            var myLabels = [String: Any]()
            
            if let labels = localProfile["labels"] {
                myLabels["labels"] = labels
            }
            
            response.sendJSONBodyWithSuccess(json: myLabels)
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
