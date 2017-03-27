//
//  User.swift
//  MisionServer
//
//  Created by Tao on 2017-03-17.
//
//

import Foundation
import MySQLStORM
import StORM

class User: MySQLStORM {
    
    // MARK: - Required
    var id: Int = 0
    var facebook_id: Int = 0
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
//    var labels: [Label]?
    
    override func table() -> String {
        return "user"
    }
    
    override func to(_ this: StORMRow) {
        id          = this.data["id"] as? Int ?? 0
        facebook_id = this.data["facebook_id"] as? Int ?? 0
        first_name  = this.data["first_name"] as? String ?? ""
        last_name   = this.data["last_name"] as? String ?? ""
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
        
//        if let labelRows = try? sqlRows("select * from labels where id = (select label_id from users_labels where user_id = ?)", params: ["\(id)"]) {
//            
//            labels = labelRows.map {
//                let label = Label()
//                label.to($0)
//                return label
//            }
//        }
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
