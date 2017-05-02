//
//  ModelFactoryUser.swift
//  MisionServer
//
//  Created by Tao on 2017-03-18.
//
//

import Foundation
import PerfectLogger

struct UserFactory {
    
    static func findUserBy(facebookID: String) -> User? {
        let user = User()
        
        do {
            try user.find(["facebook_id": facebookID])
        } catch {
            LogFile.error("User query by facebook failed: \(error.localizedDescription)")
            
            return nil
        }
        
        return user._id.isEmpty ? nil : user
    }
    
    static func findUserBy(id: String) -> User? {
        let user = User()
        
        do {
            try user.get(id)
        } catch {
            LogFile.error("User query by id failed: \(error.localizedDescription)")
            
            return nil
        }
        
        return user
    }
    
    static func create(userInfo: [String: Any]) throws -> User? {
        
        guard let facebook_id = userInfo["id"] as? String else {
            LogFile.error("Can not find user facebook id!")
            
            throw DatabaseException.create
        }
        
        let newUser         = User()
        newUser._id         = newUser.newUUID()
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
            
            throw error
        }
    }
}
