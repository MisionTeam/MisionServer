//
//  User.swift
//  MisionServer
//
//  Created by Tao on 2017-03-17.
//
//

import Foundation
import MongoDBStORM
import StORM

class User: MongoDBStORM {
    
    // MARK: - Required
    var id: String = ""
    var facebook_id: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var gender: String = ""
    var birthday: String = ""
    var email: String = ""
    
    var phone: String = ""
    var avatar: String = ""
    var job: String = ""
    var has_car: Int = 0
    var lat: Double = 0.0
    var lng: Double = 0.0
    var country: String = ""
    var state: String = ""
    var city: String = ""
    var street: String = ""
    var postal_code: String = ""
    
    override init() {
        super.init()
        
        _collection = "user"
    }
    
    override func to(_ this: StORMRow) {
        id          = this.data["_id"] as? String ?? ""
        facebook_id = this.data["facebook_id"] as? String ?? ""
        first_name  = this.data["firstname"] as? String ?? ""
        last_name   = this.data["lastname"] as? String ?? ""
        gender      = this.data["gender"] as? String ?? ""
        birthday    = this.data["birthday"] as? String ?? ""
        email       = this.data["email"] as? String ?? ""
        phone       = this.data["phone"] as? String ?? ""
        avatar      = this.data["avatar"] as? String ?? ""
        job         = this.data["job"] as? String ?? ""
        has_car     = this.data["has_car"] as? Int ?? 0
        lat         = this.data["lat"] as? Double ?? 0.0
        lng         = this.data["lng"] as? Double ?? 0.0
        country     = this.data["country"] as? String ?? ""
        state       = this.data["state"] as? String ?? ""
        city        = this.data["city"] as? String ?? ""
        street      = this.data["street"] as? String ?? ""
        postal_code = this.data["postal_code"] as? String ?? ""
    }
    
    func rows() -> [User] {
        
        var rows = [User]()
        
        for i in 0..<self.results.rows.count {
            let row = User()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}
