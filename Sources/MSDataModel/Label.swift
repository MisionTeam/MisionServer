//
//  Label.swift
//  MisionServer
//
//  Created by Tao on 2017-03-17.
//
//

import MongoDBStORM
import StORM

class Label: MongoDBStORM {
    var id: String = ""
    var label: String?
    
    override init() {
        super.init()
        
        _collection = "label"
    }
    
    override func to(_ this: StORMRow) {
        id      = this.data["_id"] as? String ?? ""
        label   = this.data["label"] as? String
    }
}
