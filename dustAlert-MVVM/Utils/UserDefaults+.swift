//
//  UserDefaults+.swift
//  dustAlert-MVVM
//
//  Created by 이주상 on 2023/04/13.
//

import Foundation

extension UserDefaults {
    var myZoneDust: Dust? {
        get {
            if let myZoneDust = object(forKey: Const.Id.myZoneDust) as? Data {
                if let decoded = try? JSONDecoder().decode(Dust.self, from: myZoneDust) {
                   return decoded
                }
            }
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                set(encoded, forKey: Const.Id.myZoneDust)
            }
        }
    }    
}

