//
//  Protocols.swift
//  MisionServer
//
//  Created by Tao on 2016-12-02.
//
//

import PerfectHTTP

protocol Endpoint {
    var route: String { get }
    var method: HTTPMethod { get }
    
    static var baseURL: String { get }
    static var allEndpoints: [Self] { get }
}

protocol RoutesBuilder {
    var routes: Routes { get }
}
