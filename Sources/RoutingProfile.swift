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
        routes = Routes(baseUri: ProfileEndpoint.baseURL)
        
        buildRoutes()
    }
    
    mutating func buildRoutes() {
        routes.add(method: ProfileEndpoint.full.method, uri: ProfileEndpoint.full.route, handler: getProfileHandler)
        routes.add(method: ProfileEndpoint.basic.method, uri: ProfileEndpoint.basic.route, handler: getBasicProfileHandler)
        routes.add(method: ProfileEndpoint.preview.method, uri: ProfileEndpoint.preview.route, handler: getPreviewProfileHandler)
        routes.add(method: ProfileEndpoint.labels.method, uri: ProfileEndpoint.labels.route, handler: getMyLabelsHandler)
        routes.add(method: ProfileEndpoint.update.method, uri: ProfileEndpoint.update.route, handler: profilePostHandler)
    }
    
    
    func getProfileHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let token = request.token else {
            
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
        
        guard let token = request.token else {
            
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
            
            response.sendJSONBodyWithSuccess(json: ["user": basicProfile])
        } else {
            response.notFound()
        }
    }
    
    func getPreviewProfileHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let token = request.token else {
            
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
            
            response.sendJSONBodyWithSuccess(json: ["user": previewProfile])
        } else {
            response.notFound()
        }
    }
    
    func getMyLabelsHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let token = request.token else {
            
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
        guard let token = request.token else {
            
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
