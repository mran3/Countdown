//
//  CounerDataService.swift
//  CounterApp
//
//  Created by Vladyslav Kozlovskyi on 12.01.2021.
//

import Foundation

class LocalCounterDataService {
    
    func getCounters(completion: @escaping ([Counter]) -> ()) {
        completion(UserDefaultsHelper.getAllObjects)
    }
    
    func saveCounters(_ models: [Counter]) {
        UserDefaultsHelper.saveAllObjects(allObjects: models)
    }
}
