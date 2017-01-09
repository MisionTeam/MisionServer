//
//  RoutingMission.swift
//  MisionServer
//
//  Created by Tao on 2017-01-08.
//
//

import PerfectLib
import PerfectHTTP

struct RoutingMission: RoutesBuilder {
    
    var routes: Routes
    
    init() {
        
        routes = Routes(baseUri: MissionEndpoint.baseURL)
        
        buildRoutes()
    }
    
    private func buildRoutes() {
    
    }
    
}
