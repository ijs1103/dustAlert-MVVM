//
//  DBManager.swift
//  dustAlert
//
//  Created by 이주상 on 2023/02/08.
//

import Foundation

final class DBManager {
    
    static let shared = DBManager()
    private init() {}
    
    func getMyZoneDustFromDB() -> Dust? {
        let userDefaults = UserDefaults.standard
        if let myZoneDust = userDefaults.object(forKey: Const.Id.myZoneDust) as? Data {
            if let decoded = try? JSONDecoder().decode(Dust.self, from: myZoneDust) {
               return decoded
            }
        }
        return nil
    }
    
    func getLikeLocationFromDB() -> [String] {
        let userDefaults = UserDefaults.standard
        if let likedDust = userDefaults.object(forKey: Const.Id.likedDust) as? Data {
            if let decodedLikeLocation = try? JSONDecoder().decode(Set<String>.self, from: likedDust) {
                return decodedLikeLocation.sorted()
            }
        }
        return []
    }
    
    func setMyZoneToDB(dust myZoneDust: Dust) {
        let userDefaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(myZoneDust) {
            userDefaults.set(encoded, forKey: Const.Id.myZoneDust)
        }
    }
    
    func setLikeLocationToDB(location: String) {
        let userDefaults = UserDefaults.standard
        // userDefaults에 즐겨찾기한 미세먼지들이 존재하면 기존의 배열에 append한 다음에 저장, 존재하지 않으면 literal로 배열을 생성하여 저장
        if let likeLocation = userDefaults.object(forKey: Const.Id.likedDust) as? Data {
            if var decodedLikeLocation = try? JSONDecoder().decode(Set<String>.self, from: likeLocation) {
                decodedLikeLocation.insert(location)
                if let encodedLikeLocation = try? JSONEncoder().encode(decodedLikeLocation) {
                    userDefaults.set(encodedLikeLocation, forKey: Const.Id.likedDust)
                }
            }
        } else {
            if let encoded = try? JSONEncoder().encode([location]) {
                userDefaults.set(encoded, forKey: Const.Id.likedDust)
            }
        }
    }
    
    func deleteLikeLocationFromDB(location: String) {
        let userDefaults = UserDefaults.standard
        
        if let likeLocation = userDefaults.object(forKey: Const.Id.likedDust) as? Data {
            if var decodedLikeLocation = try? JSONDecoder().decode(Set<String>.self, from: likeLocation){
                decodedLikeLocation.remove(location)
                if let encodedLikeLocation = try? JSONEncoder().encode(decodedLikeLocation) {
                    userDefaults.set(encodedLikeLocation, forKey: Const.Id.likedDust)
                }
            }
        }
        
    }
    
    func deleteAll() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
    }
}
