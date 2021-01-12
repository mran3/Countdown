//
//  UserDefaultsHelper.swift
//  CounterApp
//
//  Created by Andres Acevedo on 06.01.2021.
//

import Foundation

final class UserDefaultsHelper {
    static var getAllObjects: [Counter] {
        if let objects = UserDefaults.standard.value(forKey: AppConstants.keyForCountersArray) as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [Counter] {
                return objectsDecoded
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    static func saveAllObjects(allObjects: [Counter]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allObjects){
            UserDefaults.standard.set(encoded, forKey: AppConstants.keyForCountersArray)
        }
    }
}
