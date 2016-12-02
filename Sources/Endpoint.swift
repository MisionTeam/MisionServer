//
//  Endpoints.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectHTTP

enum APIEndpoint: Endpoint {
    
    static let base = "/api"
    
    static let allEndpoints: [APIEndpoint] = [.list]
    
    case list
    
    var uri: String {
        switch self {
        case .list: return "/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list: return .get
        }
    }
}

enum AuthEndpoint: Endpoint {
    
    static let base = "/auth"
    
    static let allEndpoints: [AuthEndpoint] = [.fbLogin, .logout]
    
    case fbLogin
    case logout
    
    var uri: String {
        switch self {
        case .fbLogin: return "/login/facebook"
        case .logout: return "/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fbLogin: return .post
        case .logout: return .delete
        }
    }
    
    //api list
    static let title: String = "Authentication"
    
    static let endpointRef: [[String: Any]] = [
        [
            "route"     : AuthEndpoint.base + AuthEndpoint.fbLogin.uri,
            "method"    : AuthEndpoint.fbLogin.method.description,
            "request"   : [["param": "fb_token"]],
            "response"  : [["param": "token"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : AuthEndpoint.base + AuthEndpoint.logout.uri,
            "method"    : AuthEndpoint.logout.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "success"], ["param": "status"], ["param": "error"]]
        ]
    ]
}

enum ProfileEndpoint: Endpoint {
    
    static let base = "/profile"
    
    static let allEndpoints: [ProfileEndpoint] = [.updateProfile, .profileFull, .profileBasic, .profilePreview, .profileLabels]
    
    case updateProfile
    case profileFull
    case profilePreview
    case profileBasic
    case profileLabels
    
    var uri: String {
        switch self {
        case .updateProfile: return ""
        case .profileFull: return "/full"
        case .profileBasic: return "/basic"
        case .profilePreview: return "/preview"
        case .profileLabels: return "/myLabels"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .updateProfile: return .post
        case .profileFull: return .get
        case .profileBasic: return .get
        case .profilePreview: return .get
        case .profileLabels: return .get
        }
    }
    
    //api list
    static let title: String = "Profile"
    
    static let endpointRef: [[String: Any]] = [
        [
            "route"     : ProfileEndpoint.base + ProfileEndpoint.profileFull.uri,
            "method"    : ProfileEndpoint.profileFull.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : ProfileEndpoint.base + ProfileEndpoint.profileBasic.uri,
            "method"    : ProfileEndpoint.profileBasic.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : ProfileEndpoint.base + ProfileEndpoint.profilePreview.uri,
            "method"    : ProfileEndpoint.profilePreview.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : ProfileEndpoint.base + ProfileEndpoint.profileLabels.uri,
            "method"    : ProfileEndpoint.profileLabels.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : ProfileEndpoint.base + ProfileEndpoint.updateProfile.uri,
            "method"    : ProfileEndpoint.updateProfile.method.description,
            "request"   : [["param": "token"], ["param": "body"]],
            "response"  : [["param": "success"], ["param": "status"], ["param": "error"]]
        ]
    ]
}



