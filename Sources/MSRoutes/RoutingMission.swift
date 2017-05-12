//
//  RoutingMission.swift
//  MisionServer
//
//  Created by Tao on 2017-01-08.
//
//

import PerfectLib
import PerfectHTTP
import MSDataModel

public struct RoutingMission: RoutesBuilder {
    
    public var routes: Routes
    
    public init() {
        
        routes = Routes(baseUri: MissionEndpoint.baseURL)
        
        buildRoutes()
    }
    
    private mutating func buildRoutes() {
        routes.add(method: MissionEndpoint.list.method, uri: MissionEndpoint.list.route, handler: getMissionList)
        routes.add(method: MissionEndpoint.detail.method, uri: MissionEndpoint.detail.route, handler: getMissionDetail)
        routes.add(method: MissionEndpoint.create.method, uri: MissionEndpoint.create.route, handler: createMission)
    }
    
    func getMissionList(request: HTTPRequest, response: HTTPResponse) {
        
        guard let userID = request.token?.toUserID else {
            response.accessDenied()
            return
        }
        
        let missionList = MissionFactory.allMissions().map { $0.asDataDict() }
        
        response.sendJSONBodyWithSuccess(json: ["missions": missionList])
    }
    
    func getMissionDetail(request: HTTPRequest, response: HTTPResponse) {
        guard let userID = request.token?.toUserID else {
            response.accessDenied()
            return
        }
        
        guard let missionID = request.param(name: "id"), !missionID.isEmpty else {
            response.missing(field: "id")
            return
        }
        
        guard let mission = MissionFactory.findMissionBy(id: missionID) else {
            response.notFound()
            return
        }
        
        response.sendJSONBodyWithSuccess(json: ["mission": mission.asDataDict()])
    }
    
    func createMission(request: HTTPRequest, response: HTTPResponse) {
        guard let userID = request.token?.toUserID else {
            response.accessDenied()
            return
        }
        
        var params = [String: Any]()
        request.params().forEach { params[$0.0] = $0.1 }
        
        let validation = validate(mission: params)
        
        if validation.isValidate {
            
            params["author_id"] = userID
            
            if let _ = MissionFactory.createMission(info: params) {
                response.sendJSONBodyWithSuccess()
            } else {
                response.internalError()
            }
            
            return
        }
        
        response.missing(field: validation.missingField)
    }
    
    private func validate(mission: [String: Any]) -> (isValidate: Bool, missingField: String) {
        
        let requiredFields = ["title", "description", "price", "post_date"]
        
        for required in requiredFields {
            guard let _ = mission[required] else {
                return (false, required)
            }
        }
        
        return (true, "")
    }
    
    // MARK: mock data
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
