//
//  DatabaseHelper.swift
//  MisionServer
//
//  Created by Tao on 2017-03-17.
//
//

import Foundation
import MongoDBStORM
import PerfectLogger

enum DatabaseException: Error {
    case create
    case update
    case delete
    case query
}

struct DatabaseHelper {
        
    enum Environment {
        case qa
        case production
        case local
        
        var host: String {
            switch self {
            case .local:
                return "127.0.0.1"
            case .qa:
                return "misiondb.cr3gpv6vckr6.ca-central-1.rds.amazonaws.com"
            case .production:
                return "misiondb.cr3gpv6vckr6.ca-central-1.rds.amazonaws.com"
            }
        }
        
        var database: String {
            switch self {
            case .local:
                return "mision_db"
            case .qa:
                return "mision_db_qa"
            case .production:
                return "mision_db"
            }
        }
    }
    
    static func initDatabase(environment: Environment) {
        MongoDBConnection.host      = environment.host
        MongoDBConnection.database  = environment.database
    }
}
