//
//  APIRouting.swift
//  MisionServer
//
//  Created by Tao on 2016-10-12.
//
//

import PerfectLib
import PerfectHTTP
import PerfectMustache

struct APIRouting {
    var routes: Routes
    
    init() {
        routes = Routes(baseUri: APIEndpoint.base)
        
        buildRoutes()
    }
    
    mutating func buildRoutes() {
        routes.add(method: .get, uri: APIEndpoint.list.rawValue, handler: apiListGetHandler)
    }
    
    func apiListGetHandler(request: HTTPRequest, response: HTTPResponse) {
        
        let webRoot = request.documentRoot
        mustacheRequest(request: request, response: response, handler: ListGetHandler(), templatePath: webRoot + "/apiList.html")
    }
}

struct ListGetHandler: MustachePageHandler {
    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
        
        let authAPI: [String: Any] = ["title": AuthEndpoint.title, "endpoints": AuthEndpoint.endpoints]
        
        contxt.extendValues(with: authAPI)
        
        do {
            try contxt.requestCompleted(withCollector: collector)
        } catch  {
            let response = contxt.webResponse
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }
}
