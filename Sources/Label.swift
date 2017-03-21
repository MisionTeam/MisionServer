//
//  Label.swift
//  MisionServer
//
//  Created by Tao on 2017-03-17.
//
//

import Foundation
import MySQLStORM
import StORM

class Label: MySQLStORM {
    var id: String = ""
    var label: String?
    
    override func table() -> String {
        return "labels"
    }
    
    override func to(_ this: StORMRow) {
        id      = this.data["id"] as? String ?? ""
        label   = this.data["label"] as? String
    }
}
