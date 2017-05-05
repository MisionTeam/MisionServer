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

public class User: MongoDBStORM {
    
    public struct Profile {
        public static let basicFields: Set<String> = ["first_name", "last_name", "email"]
        public static let requiredFields: Set<String> = ["first_name", "last_name", "email", "birthday", "gender"]
    }
    
    public var id: String {
        return _id
    }
    
    // MARK: - Required
    var _id: String = ""
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
    
    override public func to(_ this: StORMRow) {
        _id         = this.data["_id"] as? String ?? ""
        facebook_id = this.data["facebook_id"] as? String ?? ""
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
    }
    
    public func rows() -> [User] {
        
        var rows = [User]()
        
        for i in 0..<self.results.rows.count {
            let row = User()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    public func updateWith(profile: [String: Any]) throws {
        
        if let firstName = profile["first_name"] as? String, !firstName.isEmpty {
            first_name = firstName
        }
        
        if let lastName = profile["last_name"] as? String, !lastName.isEmpty {
            last_name = lastName
        }
        
        if let gender = profile["gender"] as? String, !gender.isEmpty {
            self.gender = gender
        }
        
        if let birthday = profile["birthday"] as? String, !birthday.isEmpty {
            self.birthday = birthday
        }
        
        if let email = profile["email"] as? String, !email.isEmpty {
            self.email = email
        }
        
        if let phone = profile["phone"] as? String, !phone.isEmpty {
            self.phone = email
        }
        
        if let avatar = profile["avatar"] as? String, !avatar.isEmpty {
            self.avatar = avatar
        }
        
        if let job = profile["job"] as? String, !job.isEmpty {
            self.job = job
        }
        
        if let has_car = profile["has_car"] as? Int {
            self.has_car = has_car
        }
        
        if let lat = profile["lat"] as? Double {
            self.lat = lat
        }
        
        if let lng = profile["lng"] as? Double {
            self.lng = lng
        }
        
        if let country = profile["country"] as? String, !country.isEmpty {
            self.country = country
        }
        
        if let state = profile["state"] as? String, !state.isEmpty {
            self.state = state
        }
        
        if let city = profile["city"] as? String, !city.isEmpty {
            self.city = city
        }
        
        if let street = profile["street"] as? String, !street.isEmpty {
            self.street = street
        }
        
        if let postal_code = profile["postal_code"] as? String, !postal_code.isEmpty {
            self.postal_code = postal_code
        }
        
        try save()
    }
}
