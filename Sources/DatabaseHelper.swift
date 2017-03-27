//
//  DatabaseHelper.swift
//  MisionServer
//
//  Created by Tao on 2017-03-17.
//
//

import Foundation
import MySQLStORM

enum DatabaseException: Error {
    case create
    case update
    case delete
    case query
}

struct DatabaseHelper {
    
    struct MySQLConsole {
        
        enum Enviroment {
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
        
        static let username = "root"
        static let password = "admin123"
        static let port     = 3306
    }
    
    static func initDatabase(enviroment: MySQLConsole.Enviroment) {
        MySQLConnector.host     = enviroment.host
        MySQLConnector.username = MySQLConsole.username
        MySQLConnector.password = MySQLConsole.password
        MySQLConnector.database = enviroment.database
        MySQLConnector.port     = MySQLConsole.port
    }
}
