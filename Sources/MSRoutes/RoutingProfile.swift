//
//  RoutingProfile.swift
//  MisionServer
//
//  Created by Tao on 2016-12-02.
//
//

import PerfectLib
import PerfectHTTP
import PerfectLogger
import MSDataModel

public struct RoutingProfile: RoutesBuilder {
    
    public var routes: Routes
    
    public init() {
        routes = Routes(baseUri: ProfileEndpoint.baseURL)
        
        buildRoutes()
    }
    
    mutating func buildRoutes() {
        routes.add(method: ProfileEndpoint.full.method, uri: ProfileEndpoint.full.route, handler: getProfileHandler)
        routes.add(method: ProfileEndpoint.basic.method, uri: ProfileEndpoint.basic.route, handler: getBasicProfileHandler)
        routes.add(method: ProfileEndpoint.preview.method, uri: ProfileEndpoint.preview.route, handler: getPreviewProfileHandler)
//        routes.add(method: ProfileEndpoint.labels.method, uri: ProfileEndpoint.labels.route, handler: getMyLabelsHandler)
        routes.add(method: ProfileEndpoint.update.method, uri: ProfileEndpoint.update.route, handler: profilePostHandler)
    }
    
    
    func getProfileHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let userID = request.token?.toUserID else {
            
            response.accessDenied()
            return
        }
        
        if let profile = UserFactory.findUserBy(id: userID)?.asDataDict() {
            response.sendJSONBodyWithSuccess(json: ["user": profile])
        } else {
            response.notFound()
        }
    }
    
    func getBasicProfileHandler(request: HTTPRequest, response: HTTPResponse) {
        
        guard let userID = request.token?.toUserID else {
            
            response.accessDenied()
            return
        }
        
        if let profile = UserFactory.findUserBy(id: userID)?.asDataDict() {
            
            var basicProfile = [String: Any]()
                
            for (k, v) in profile {
                if User.Profile.basicFields.contains(k) {
                    basicProfile[k] = v
                }
            }
            
            response.sendJSONBodyWithSuccess(json: ["user": basicProfile])
        } else {
            response.notFound()
        }
    }
    
    func getPreviewProfileHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let userID = request.token?.toUserID else {
            
            response.accessDenied()
            return
        }
        
        if let profile = UserFactory.findUserBy(id: userID)?.asDataDict() {
            
            var previewProfile = [String: Any]()
            
            for (k, v) in profile {
                if User.Profile.basicFields.contains(k) {
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
        guard let userID = request.token?.toUserID else {
            
            response.accessDenied()
            return
        }
        
        var update = [String: Any]()
        request.params().forEach { update[$0.0] = $0.1 }
            
        guard let _ = UserFactory.update(userID: userID, with: update) else {
            response.internalError()
            
            return
        }
        
        response.sendJSONBodyWithSuccess(json: nil)
    }
    
    //MARK: mock data
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
        
        for k in User.Profile.requiredFields {
            guard let _ = profile[k] else {
                return (false, k)
            }
        }
        
        return (true, "")
    }
}
