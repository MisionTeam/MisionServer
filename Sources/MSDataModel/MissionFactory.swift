//
//  MissionFactory.swift
//  MisionServer
//
//  Created by ZHITAO TIAN on 2017-05-06.
//
//

import PerfectLogger

public struct MissionFactory {
    
    public static func createMission(info: [String: Any]) {
        let mission         = Mission()
        mission.id          = mission.newUUID()
        mission.title       = info["title"] as? String ?? ""
        mission.description = info["description"] as? String ?? ""
        mission.status      = info["status"] as? Int ?? 0
        mission.price       = info["price"] as? Double ?? 0.0
        mission.address     = info["address"] as? String ?? ""
        mission.author_id   = info["author_id"] as? String ?? ""
        mission.post_date   = info["post_date"] as? String ?? ""
        mission.due_date    = info["due_date"] as? String ?? ""
        
        do {
            try mission.save()
        } catch {
            LogFile.error("Create mission failed!")
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
        
    }
}
