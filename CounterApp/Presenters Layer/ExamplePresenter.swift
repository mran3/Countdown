//
//  ExamplePresenter.swift
//  CounterApp
//
//  Created by Andres Acevedo on 12.01.2021.
//

import UIKit

// MARK: - ExampleView

protocol ExampleView: class {
    func fillArrForTV(models: [ExamplesModels])
}

class ExamplePresenter {
    
    // MARK: - Private Properties
    
    weak fileprivate var exampleView: ExampleView!
    
    // MARK: - Lifecycle
    
    init() {}
    
    func attachView(_ exampleView: ExampleView) {
        self.exampleView = exampleView
    }
    
    func deatachView() {
        self.exampleView = nil
    }
    
    func fillArrData() {
        let drinks = ExamplesModels(title: "DRINKS", countersName: ["Cups of coffee", "Glasses of water", "Coffee"])
        let foods = ExamplesModels(title: "Food", countersName: ["Hot-dogs", "Cupcakes eaten", "Chicken"])
        let music = ExamplesModels(title: "Music", countersName: ["Times sneezed", "Naps", "Day dreaming"])
        
        exampleView.fillArrForTV(models: [drinks, foods, music])
    }
}
