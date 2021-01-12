//
//  CounterAPI.swift
//  CounterApp
//
//  Created by Andres Acevedo on 11/01/21.
//

import Foundation
import Moya

enum CounterAPITarget: TargetType {
    
    case list
    case create(title: String)
    case delete(deletionId: String)
    case increment(counterId: String)
    case decrement(counterId: String)
    
    var path: String {
        switch self {
        case .list:
            return "/counters"
        case .increment:
            return "/counter/inc"
        case .decrement:
            return "/counter/dec"
        default:
            return "/counter"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list:
            return .get
        case .create:
            return .post
        case .delete:
            return .delete
        case .increment:
            return .post
        case .decrement:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .create (let title):
            return .requestParameters(parameters: ["title": title], encoding: JSONEncoding.default)
        case .delete (let deletionId):
            return .requestParameters(parameters: ["id": deletionId], encoding: JSONEncoding.default)
        case .increment(let counterId):
            return .requestParameters(parameters: ["id": counterId], encoding: JSONEncoding.default)
        case .decrement(let counterId):
            return .requestParameters(parameters: ["id": counterId], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
        
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var baseURL: URL {
        return URL(string: "http://localhost:3000/api/v1")!
    }
}
