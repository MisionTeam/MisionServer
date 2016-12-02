//
//  Protocols.swift
//  MisionServer
//
//  Created by Tao on 2016-12-02.
//
//

import PerfectHTTP

protocol Endpoint {
    var uri: String { get }
    var method: HTTPMethod { get }
}

protocol RoutesBuilder {
    var routes: Routes { get }
}
