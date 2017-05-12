//
//  MissionFactory.swift
//  MisionServer
//
//  Created by ZHITAO TIAN on 2017-05-06.
//
//

import PerfectLogger

public struct MissionFactory {
    
    public static func createMission(info: [String: Any]) -> Mission? {
        let mission         = Mission()
        mission.id          = mission.newUUID()
        mission.title       = info["title"] as? String ?? ""
        mission.description = info["description"] as? String ?? ""
        mission.status      = info["status"] as? Int ?? MissionStatus.open.rawValue
        mission.price       = info["price"] as? Double ?? 0.0
        mission.address     = info["address"] as? String ?? ""
        mission.author_id   = info["author_id"] as? String ?? ""
        mission.accepter_id = info["accepter_id"] as? String ?? ""
        mission.post_date   = info["post_date"] as? String ?? ""
        mission.due_date    = info["due_date"] as? String ?? ""
        
        do {
            try mission.save()
            return mission
        } catch {
            LogFile.error("Create mission failed!")
            return nil
        }
    }
    
    public static func allMissions() -> [Mission] {
        
        let mission = Mission()
        
        do {
            try mission.find()
            
            return mission.rows()
        } catch {
            LogFile.error("Find mission list failed!")
            
            return []
        }
    }
    
    public static func findMissionBy(id: String) -> Mission? {
        
        let mission = Mission()
        
        do {
            try mission.get(id)
            
            return mission
        } catch {
            LogFile.error("find mission by id failed! mission id: \(id)")
            
            return nil
        }
    }
    
    public static func deleteMissionBy(id: String) {
        
        guard let mission = findMissionBy(id: id) else {
            return
        }
        
        do {
            try mission.delete()
        } catch {
            LogFile.error("Delete mission failed! mission id: \(id)")
        }
    }
    
    public static func updateMission(id: String, info: [String: Any]) -> Mission? {
        
        guard let mission = findMissionBy(id: id) else {
            return nil
        }
        
        if let title = info["title"] as? String, !title.isEmpty {
            mission.title = title
        }
        
        if let description = info["description"] as? String {
            mission.description = description
        }
        
        if let status = info["status"] as? Int {
            mission.status = status
        }
        
        if let price = info["price"] as? Double {
            mission.price = price
        }
        
        if let address = info["address"] as? String {
            mission.address = address
        }
        
        if let accepter_id = info["accepter_id"] as? String {
            mission.accepter_id = accepter_id
        }
        
        if let due_date = info["due_date"] as? String {
            mission.due_date = due_date
        }
        
        do {
            try mission.save()
            
            return mission
        } catch {
            LogFile.error("Update mission failed! mission id: \(id)")
            
            return nil
        }
    }
}
