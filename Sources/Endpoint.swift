//
//  Endpoints.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import PerfectHTTP

// MARK: - API doc

enum APIEndpoint: Endpoint {
    
    static var baseURL: String = "/api"
    
    static let allEndpoints: [APIEndpoint] = [.list]
    
    case list
    
    var route: String {
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

// MARK: - Auth

enum AuthEndpoint: Endpoint {
    
    static let baseURL: String = "/auth"
    
    static let allEndpoints: [AuthEndpoint] = [.fbLogin, .logout]
    
    case fbLogin
    case logout
    
    var route: String {
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
    
    static let title: String = "Authentication"
    
    static let endpointRef: [[String: Any]] = [
        [
            "route"     : AuthEndpoint.baseURL + AuthEndpoint.fbLogin.route,
            "method"    : AuthEndpoint.fbLogin.method.description,
            "request"   : [["param": "fb_token"]],
            "response"  : [["param": "token"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : AuthEndpoint.baseURL + AuthEndpoint.logout.route,
            "method"    : AuthEndpoint.logout.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "success"], ["param": "status"], ["param": "error"]]
        ]
    ]
}

// MARK: - Profile

enum ProfileEndpoint: Endpoint {
    
    static var baseURL: String = "/profile"
    
    static let allEndpoints: [ProfileEndpoint] = [.update, .full, .basic, .preview, .labels]
    
    case update
    case full
    case preview
    case basic
    case labels
    
    var route: String {
        switch self {
        case .update: return ""
        case .full: return "/full"
        case .basic: return "/basic"
        case .preview: return "/preview"
        case .labels: return "/myLabels"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .update: return .post
        default: return .get
        }
    }
    
    static let title: String = "Profile"
    
    static let endpointRef: [[String: Any]] = [
        [
            "route"     : ProfileEndpoint.baseURL + ProfileEndpoint.full.route,
            "method"    : ProfileEndpoint.full.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : ProfileEndpoint.baseURL + ProfileEndpoint.basic.route,
            "method"    : ProfileEndpoint.basic.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : ProfileEndpoint.baseURL + ProfileEndpoint.preview.route,
            "method"    : ProfileEndpoint.preview.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : ProfileEndpoint.baseURL + ProfileEndpoint.labels.route,
            "method"    : ProfileEndpoint.labels.method.description,
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"], ["param": "success"], ["param": "status"], ["param": "error"]]
        ],
        [
            "route"     : ProfileEndpoint.baseURL + ProfileEndpoint.update.route,
            "method"    : ProfileEndpoint.update.method.description,
            "request"   : [["param": "token"], ["param": "body"]],
            "response"  : [["param": "success"], ["param": "status"], ["param": "error"]]
        ]
    ]
}

// MARK: - Mission

enum MissionEndpoint: Endpoint {
    
    static var baseURL: String = "/mission"
    
    static var allEndpoints: [MissionEndpoint] = [.list, .detail]
    
    case list
    case detail
    
    var route: String {
        switch self {
        case .list: return "/list"
        case .detail: return "/detail"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    static let title: String = "Mission"
    
    static let endpointRef: [[String: Any]] = [
        [
            "route"     : MissionEndpoint.baseURL + MissionEndpoint.list.route,
            "method"    : MissionEndpoint.list.method.description,
            
            "request"   : [["param": "token"],
                           ["param": "lat"],
                           ["param": "lng"],
                           ["param": "status"],
                           ["param": "author"],
                           ["param": "page"],
                           ["param": "missionsPerPage"],
                           ["param": "category"]],
            
            "response"  : [["param": "body"],
                           ["param": "success"],
                           ["param": "status"],
                           ["param": "error"]]
        ],
        [
            "route"     : MissionEndpoint.baseURL + MissionEndpoint.detail.route,
            "method"    : MissionEndpoint.detail.method.description,
            
            "request"   : [["param": "token"],
                           ["param": "id"]],
            
            "response"  : [["param": "body"],
                           ["param": "success"],
                           ["param": "status"],
                           ["param": "error"]]
        ]
    ]
}



