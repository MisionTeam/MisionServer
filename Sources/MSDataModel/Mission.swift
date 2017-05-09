//
//  Mission.swift
//  MisionServer
//
//  Created by ZHITAO TIAN on 2017-05-06.
//
//

import MongoDBStORM
import StORM

public class Mission: MongoDBStORM {
    
    var id: String = ""
    var title: String = ""
    var description: String = ""
    var status: Int = 0
    var price: Double = 0.0
    var author_id: String = ""
    var address: String = ""
    var post_date: String = ""
    var due_date: String = ""
//    var comments: String = ""
    
    override init() {
        super.init()
        
        _collection = "mission"
    }
    
    public override func to(_ this: StORMRow) {
        id          = this.data["id"] as? String ?? ""
        title       = this.data["title"] as? String ?? ""
        description = this.data["description"] as? String ?? ""
        status      = this.data["status"] as? Int ?? 0
        price       = this.data["price"] as? Double ?? 0.0
        author_id   = this.data["author_id"] as? String ?? ""
        address     = this.data["address"] as? String ?? ""
        post_date   = this.data["post_date"] as? String ?? ""
        due_date    = this.data["due_date"] as? String ?? ""
//        comments    = this.data["comments"] as? String ?? ""
    }
    
    public func rows() -> [Mission] {
        
        var rows = [Mission]()
        
        for i in 0..<self.results.rows.count {
            let row = Mission()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}
