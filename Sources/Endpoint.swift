//
//  Endpoints.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import Foundation

enum APIEndpoint: String {
    
    static var base: String { return "/api" }
    
    case list = "/list"
}

enum AuthEndpoint: String {
    
    static var base: String { return "/auth" }
    
    case login      = "/login"
    case profile    = "/profile"
    case logout     = "/logout"
    
    static let title: String    = "Authentication"
    static let endpoints: [[String: Any]] = [
        [
            "route"     : AuthEndpoint.base + AuthEndpoint.login.rawValue,
            "method"    : "POST",
            "request"   : [["param": "fb_token"]],
            "response"  : [["param": "success"], ["param": "statusCode"], ["param": "token"]]
        ],
        [
            "route"     : AuthEndpoint.base + AuthEndpoint.profile.rawValue,
            "method"    : "GET",
            "request"   : [["param": "token"]],
            "response"  : [["param": "body"]]
        ],
        [
            "route"     : AuthEndpoint.base + AuthEndpoint.profile.rawValue,
            "method"    : "POST",
            "request"   : [["param": "token"], ["param": "body"]],
            "response"  : [["param": "success"], ["param": "statusCode"], ["param": "token"]]
        ],
        [
            "route"     : AuthEndpoint.base + AuthEndpoint.logout.rawValue,
            "method"    : "DELETE",
            "request"   : [["param": "token"]],
            "response"  : [["param": "success"], ["param": "statusCode"], ["param": "token"]]
        ]
    ]
}



