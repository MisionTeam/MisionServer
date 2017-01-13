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
    
    private mutating func buildRoutes() {
        routes.add(method: MissionEndpoint.list.method, uri: MissionEndpoint.list.route, handler: getMissionList)
        routes.add(method: MissionEndpoint.detail.method, uri: MissionEndpoint.detail.route, handler: getMissionDetail)
    }
    
    func getMissionList(request: HTTPRequest, response: HTTPResponse) {
        
        guard let token = request.param(name: "token"), !token.isEmpty else {
            
            response.accessDenied()
            return
        }
        
        if let localList = loadLocalMissionList() {
            response.sendJSONBodyWithSuccess(json: ["missions": localList])
        } else {
            response.notFound()
        }
    }
    
    func getMissionDetail(request: HTTPRequest, response: HTTPResponse) {
        guard let token = request.param(name: "token"), !token.isEmpty else {
            
            response.accessDenied()
            return
        }
        
        guard let missionID = request.param(name: "id"), !missionID.isEmpty else {
            
            response.missing(field: "id")
            return
        }
        
        if let localDetail = loadLocalMissionDetail() {
            response.sendJSONBodyWithSuccess(json: ["mission": localDetail])
        } else {
            response.notFound()
        }
    }
    
    private func loadLocalMissionList() -> [[String: Any]]? {
        let listFile = File("./webroot/missionList.json")
        
        if let jsonString = try? listFile.readString() {
            if let decoded = (try? jsonString.jsonDecode()) as? [[String: Any]] {
                return decoded
            }
        }
        
        return nil
    }
    
    private func loadLocalMissionDetail() -> [String: Any]? {
        let detailFile = File("./webroot/missionDetail.json")
        
        if let jsonString = try? detailFile.readString() {
            if let decoded = (try? jsonString.jsonDecode()) as? [String: Any] {
                return decoded
            }
        }
        
        return nil
    }
}
