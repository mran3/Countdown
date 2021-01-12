//
//  CounterModel.swift
//  CounterApp
//
//  Created by Andres Acevedo on 06.01.2021.
//

import Foundation
import Moya

struct Counter: Codable, Hashable {
    var id: String
    var title: String?
    var count: Int
}

class RemoteCounterService {
    var counters = [Counter]()
    let provider = MoyaProvider<CounterAPITarget>()
    
    func getCounters(completion: @escaping (Result<Bool, Error>) -> ()){
        provider.request(.list) { result in
            switch result {
            case .success(let response):
                do {
//                    print(try response.mapJSON())
                    self.counters = try response.map([Counter].self)
                    completion(.success(!self.counters.isEmpty))
                } catch {
                    print("Unexpected error: \(error).")
                    completion(.failure(error))
                }
                
            case .failure(let error):
                print("failed network request")
                completion(.failure(error))
            }
        }
    }
    
    func deleteCounter(deletionId: String, completion: @escaping (Result<Response, MoyaError>) -> ()){
        provider.request(.delete(deletionId: deletionId)) { result in
            completion(result)
        }
    }
    
    func createCounter(title: String, completion: @escaping (Result<Response, MoyaError>) -> ()){
        provider.request(.create(title: title)) { result in
            completion(result)
        }
    }
    
}
