//
//  Endpoints.swift
//  MisionServer
//
//  Created by Tao on 2016-10-04.
//
//

import Foundation

enum AuthEndpoint: String {
    
    static var base: String { return "/auth" }
    
    case login      = "/login"
    case profile    = "/profile"
    case logout     = "/logout"
}

