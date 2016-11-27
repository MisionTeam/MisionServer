//
//  Endpoints.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectHTTP

enum APIEndpoint {
    
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

enum AuthEndpoint {
    
    static let base = "/auth"
    
    static let allEndpoints: [AuthEndpoint] = [.fbLogin, .updateProfile, .profileFull, .profileBasic, .profilePreview, .profileLabels, .logout]
    
    case fbLogin
    case updateProfile
    case profileFull
    case profilePreview
    case profileBasic
    case profileLabels
    case logout
    
    var uri: String {
        switch self {
        case .fbLogin: return "/login/facebook"
        case .updateProfile: return "/profile"
        case .profileFull: return "/profile/full"
        case .profileBasic: return "/profile/basic"
        case .profilePreview: return "/profile/preview"
        case .profileLabels: return "/profile/myLabels"
        case .logout: return "/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fbLogin: return .get
        case .updateProfile: return .post
        case .profileFull: return .get
        case .profileBasic: return .get
        case .profilePreview: return .get
        case .profileLabels: return .get
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
            "route"     : AuthEndpoint.base + AuthEndpoint.profileFull.uri,
            "method"    : AuthEndpoint.profileFull.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : AuthEndpoint.base + AuthEndpoint.profileBasic.uri,
            "method"    : AuthEndpoint.profileBasic.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : AuthEndpoint.base + AuthEndpoint.profilePreview.uri,
            "method"    : AuthEndpoint.profilePreview.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : AuthEndpoint.base + AuthEndpoint.profileLabels.uri,
            "method"    : AuthEndpoint.profileLabels.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : AuthEndpoint.base + AuthEndpoint.updateProfile.uri,
            "method"    : AuthEndpoint.updateProfile.method.description,
            "request"   : [["param": "token"], ["param": "body"]],
            "response"  : [["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : AuthEndpoint.base + AuthEndpoint.logout.uri,
            "method"    : AuthEndpoint.logout.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "success"], ["param": "status"], ["param": "error"]]
        ]
    ]
}



