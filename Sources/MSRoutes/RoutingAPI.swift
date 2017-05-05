//
//  RoutingAPI.swift
//  MisionServer
//
//  Created by Tao on 2016-10-12.
//
//

import PerfectLib
import PerfectHTTP
import PerfectMustache

public struct RoutingAPI: RoutesBuilder {
    public var routes: Routes
    
    public init() {
        routes = Routes(baseUri: APIEndpoint.baseURL)
        
        buildRoutes()
    }
    
    mutating func buildRoutes() {
        routes.add(method: APIEndpoint.list.method, uri: APIEndpoint.list.route, handler: apiListGetHandler)
    }
    
    func apiListGetHandler(request: HTTPRequest, response: HTTPResponse) {
        
        let webRoot = request.documentRoot
        mustacheRequest(request: request, response: response, handler: ListGetHandler(), templatePath: webRoot + "/apiList.html")
    }
}

struct ListGetHandler: MustachePageHandler {
    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
        
        let authAPI: [String: Any]      = ["title": AuthEndpoint.title, "endpoints": AuthEndpoint.endpointRef]
        let profileAPI: [String: Any]   = ["title": ProfileEndpoint.title, "endpoints": ProfileEndpoint.endpointRef]
        let missionAPI: [String: Any]   = ["title": MissionEndpoint.title, "endpoints": MissionEndpoint.endpointRef]
        
        let listOfAPI: [String: Any] = ["apiList": [authAPI, profileAPI, missionAPI]]
        
        contxt.extendValues(with: listOfAPI)
        
        do {
            try contxt.requestCompleted(withCollector: collector)
        } catch {
            let response = contxt.webResponse
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }
}
