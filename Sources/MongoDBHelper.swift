//
//  MongoDBHelper.swift
//  MisionServer
//
//  Created by Tao on 2016-11-14.
//
//

import MongoDB

struct MongoDBHelper {
    
    init(uri: String = MongoDB.uri) {
        
        self.client = try! MongoClient(uri: uri)
    }
    
    private var client: MongoClient
    
    func testDBInsert() -> Bool {
        
        if let testJSON = try? ["name": "test"].jsonEncodedString() {
            if let bson = try? BSON(json: testJSON) {
                return insert(name: MongoDB.Database.test, collection: MongoDB.Collection.test, bson: bson)
            }
        }
        
        return false
    }
    
    func testDBRead() {

        let result = query(name: MongoDB.Database.test, collection: MongoDB.Collection.test, bson: BSON())
        
        result.forEach { print("\($0)\n") }
    }
    
    func getUser(id: String) -> BSON {
        return BSON()
    }
    
    private struct MongoDB {
        static let uri = "mongodb://localhost"
        
        struct Database {
            static let test = "test"
            static let production = "production"
        }
        
        struct Collection {
            static let test = "test_collection"
            static let user = "user"
            static let mission = "mission"
        }
    }
    
    private func query(name: String, collection: String, bson: BSON) -> [String] {
        let dbCollection = MongoCollection(client: client, databaseName: name, collectionName: collection)
        
        var find = [String]()
        
        if let result = dbCollection.find(query: bson) {
            result.forEach { find.append($0.asString) }
        }
        
        return find
    }
    
    private func insert(name: String, collection: String, bson: BSON) -> Bool {
        
        let dbCollection = MongoCollection(client: client, databaseName: name, collectionName: collection)
        let result = dbCollection.insert(document: bson)
        
        return checkResult(result: result)
    }
    
    private func update(name: String, collection: String, update: BSON, selector: BSON) -> Bool {
        let dbCollection = MongoCollection(client: client, databaseName: name, collectionName: collection)
        let result = dbCollection.update(selector: selector, update: update)
        
        return checkResult(result: result)
    }
    
    private func delete(name: String, collection: String, selector: BSON) -> Bool {
        let dbCollection = MongoCollection(client: client, databaseName: name, collectionName: collection)
        let result = dbCollection.remove(selector: selector)
        
        return checkResult(result: result)
    }
    
    
    private func checkResult(result: MongoResult) -> Bool {
        switch result {
        case .success:
            return true
        case let .error(domain, code,  message):
            print("domain: \(domain), code: \(code), error message: \(message)")
            return false
        default:
            return false
        }
    }
}

