//
//  ModelFactoryUser.swift
//  MisionServer
//
//  Created by Tao on 2017-03-18.
//
//

import Foundation

struct UserFactory {
    
    static func findUserBy(facebookID: String) -> User? {
        let user = User()
        
        do {
            try user.find(["facebook_id": facebookID])
        } catch {
            print("find user by facebook failed: \(error.localizedDescription)")
            return nil
        }
        
        return user.id > 0 ? user : nil
    }
    
    static func create(userInfo: [String: Any], facebookID: Int) {
        let newUser = User()
        
        newUser.facebook_id = facebookID
        newUser.first_name  = userInfo["firstName"] as? String ?? ""
        newUser.last_name   = userInfo["lastName"] as? String ?? ""
        newUser.gender      = userInfo["gender"] as? String ?? ""
        newUser.birthday    = userInfo["birthday"] as? String ?? ""
        newUser.email       = userInfo["email"] as? String ?? ""
        newUser.phone       = userInfo["phone"] as? String ?? ""
        newUser.job         = userInfo["job"] as? String ?? ""
        newUser.has_car     = userInfo["hasCar"] as? Int ?? 0
        newUser.avatar      = userInfo["avatar"] as? String ?? ""
        
        do {
            try newUser.save { newUser.id = $0 as! Int }
        } catch {
            print("create new user fialed: \(error.localizedDescription)")
        }
    }
}
