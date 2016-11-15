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
    
    func testDB() {
        
        defer {
            collection.close()
            client.close()
        }
        
        let collection = MongoCollection(client: client, databaseName: MongoDB.Database.test, collectionName: MongoDB.Collection.test)
    }
    
    func getUser(id: String) -> BSON {
        return BSON()
    }
    
    private struct MongoDB {
        static let uri = "mongodb://localhost"
        
        struct Database {
            static let test = "test"
        }
        
        struct Collection {
            static let test = "testcollection"
        }
    }
    
    private func query(name: String, collection: String) -> BSON {
        return BSON()
    }
    
    private func insert(name: String, collection: String, bson: BSON) -> Bool {
        return true
    }
    
    private func update(name: String, collection: String, bson: BSON) -> Bool {
        return true
    }
    
    private func delete(name: String, collection: String, bson: BSON) -> Bool {
        return true
    }
    
    
}

