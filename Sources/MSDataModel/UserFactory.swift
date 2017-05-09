//
//  ModelFactoryUser.swift
//  MisionServer
//
//  Created by Tao on 2017-03-18.
//
//

import Foundation
import PerfectLogger

public struct UserFactory {
    
    public static func findUserBy(facebookID: String) -> User? {
        let user = User()
        
        do {
            try user.find(["facebook_id": facebookID])
        } catch {
            LogFile.error("User query by facebook failed: \(error.localizedDescription)")
            
            return nil
        }
        
        return user.id.isEmpty ? nil : user
    }
    
    public static func findUserBy(id: String) -> User? {
        let user = User()
        
        do {
            try user.get(id)
        } catch {
            LogFile.error("User query by id failed: \(error.localizedDescription)")
            
            return nil
        }
        
        return user
    }
    
    public static func create(userInfo: [String: Any]) -> User? {
        
        guard let facebook_id = userInfo["id"] as? String else {
            LogFile.error("Can not find user facebook id!")
            
            return nil
        }
        
        let newUser         = User()
        newUser.id          = newUser.newUUID()
        newUser.facebook_id = facebook_id
        newUser.first_name  = userInfo["first_name"] as? String ?? ""
        newUser.last_name   = userInfo["last_name"] as? String ?? ""
        newUser.gender      = userInfo["gender"] as? String ?? ""
        newUser.birthday    = userInfo["birthday"] as? String ?? ""
        newUser.email       = userInfo["email"] as? String ?? ""
        newUser.phone       = userInfo["phone"] as? String ?? ""
        newUser.job         = userInfo["job"] as? String ?? ""
        newUser.has_car     = userInfo["hasCar"] as? Int ?? 0
        newUser.avatar      = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String ?? ""
        
        do {
            try newUser.save()
            
            return newUser
        } catch {
            LogFile.error("New user create fialed: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    public static func update(userID: String, with profile: [String: Any]) -> User? {
        guard let user = findUserBy(id: userID) else {
            return nil
        }
        
        if let firstName = profile["first_name"] as? String, !firstName.isEmpty {
            user.first_name = firstName
        }
        
        if let lastName = profile["last_name"] as? String, !lastName.isEmpty {
            user.last_name = lastName
        }
        
        if let gender = profile["gender"] as? String, !gender.isEmpty {
            user.gender = gender
        }
        
        if let birthday = profile["birthday"] as? String, !birthday.isEmpty {
            user.birthday = birthday
        }
        
        if let email = profile["email"] as? String, !email.isEmpty {
            user.email = email
        }
        
        if let phone = profile["phone"] as? String, !phone.isEmpty {
            user.phone = phone
        }
        
        if let avatar = profile["avatar"] as? String, !avatar.isEmpty {
            user.avatar = avatar
        }
        
        if let job = profile["job"] as? String, !job.isEmpty {
            user.job = job
        }
        
        if let has_car = profile["has_car"] as? Int {
            user.has_car = has_car
        }
        
        if let lat = profile["lat"] as? Double {
            user.lat = lat
        }
        
        if let lng = profile["lng"] as? Double {
            user.lng = lng
        }
        
        if let country = profile["country"] as? String, !country.isEmpty {
            user.country = country
        }
        
        if let state = profile["state"] as? String, !state.isEmpty {
            user.state = state
        }
        
        if let city = profile["city"] as? String, !city.isEmpty {
            user.city = city
        }
        
        if let street = profile["street"] as? String, !street.isEmpty {
            user.street = street
        }
        
        if let postal_code = profile["postal_code"] as? String, !postal_code.isEmpty {
            user.postal_code = postal_code
        }
        
        do {
            try user.save()
            
            return user
        } catch {
            LogFile.error("Update user profile failed: \(error.localizedDescription)")
            return nil
        }
    }
}
