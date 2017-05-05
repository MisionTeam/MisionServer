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

public enum DatabaseException: Error {
    case create
    case update
    case delete
    case query
}

public struct DatabaseHelper {
        
    public enum Environment {
        case qa
        case production
        case local
        
        var host: String {
            switch self {
            case .local:
                return "localhost"
            case .qa:
                return "localhost"
            case .production:
                return "ec2-52-60-82-23.ca-central-1.compute.amazonaws.com"
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
    
    public static func initDatabase(environment: Environment) {
        MongoDBConnection.host      = environment.host
        MongoDBConnection.database  = environment.database
    }
}
