//
//  CounterListPresenter.swift
//  CounterApp
//
//  Created by Andres Acevedo on 12.01.2021.
//

import Foundation

// MARK: - CountersListView

protocol CountersListView: class {
    func setCounters(_ countes: [Counter])
    func setupCountersLabelText(text: String, isHidden: Bool)
    func endRefreshing()
    func openShareController(textToShare: [String])
    func deleteCounters(_ newModelsArr: [Counter])
    func updateCountersArr(newArr: [Counter])
    func showAlert()
}

class CounterListPresenter {
    
    // MARK: - Private Properties
    
    fileprivate let localService: LocalCounterDataService!
    weak fileprivate var countersView: CountersListView!
    var remoteService = RemoteCounterService()
    // MARK: - Lifecycle
    
    init(service: LocalCounterDataService) {
        self.localService = service
    }
    
    func attachView(_ countersView: CountersListView) {
        self.countersView = countersView
    }
    
    func deatachView() {
        self.countersView = nil
    }
    
    func getCounters() {
        print("get from network")
        remoteService.getCounters(){ [weak self] result in
            guard let self = self else {
                print("Self was deallocated")
                return
            }
            switch result {
            case .success(_):
                print("callback succ")
                let receivedModels = self.remoteService.counters
                self.countersView.setCounters(receivedModels)
                self.localService.saveCounters(receivedModels)
                
            case .failure(_):
                print("callback fail")
                self.localService.getCounters { models in
                    self.countersView.setCounters(models)
                }
            }
            self.countersView.endRefreshing()
        }
        
    }
    
    func deleteCounters(allModels: [Counter], modelsToDelete: [Counter]) {
        let group = DispatchGroup();
        
        for model in modelsToDelete {
            group.enter()
            remoteService.deleteCounter(deletionId: model.id) { result in
                print("counter deleted")
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.refreshData()
        }
        
    }
    
    
    func refreshData() {
        self.getCounters()
    }
    
    func saveCounters(_ models: [Counter]) {
        localService.saveCounters(models)
    }

    
    func increaseCounter(counterId: String) {
        remoteService.increaseCounter(counterId: counterId) { result in
            switch (result) {
            case .success:
                self.refreshData()
            case .failure:
                self.countersView.showAlert()
            }
        }
    }
    
    func decreaseCounter(counterId: String) {
        remoteService.decreaseCounter(counterId: counterId) { result in
            switch (result) {
            case .success:
                self.refreshData()
            case .failure:
                self.countersView.showAlert()
            }
        }
    }
    
    func shareSelectedCountersText(for modelsToShare: [Counter]) {
        guard modelsToShare.count > 0 else { return }
        var textToShare: [String] = []
        modelsToShare.forEach({ model in
            textToShare.append("\(model.count) × \(model.title ?? "Untitled Counter")")
        })
        countersView.openShareController(textToShare: textToShare)
    }
    
    func setupContersLabelText(for models: [Counter]) {
        var counerOfClicks = 0
        for model in models {
            counerOfClicks += model.count
        }
        let text = "\(models.count) items · Counted \(counerOfClicks) times"
        countersView.setupCountersLabelText(text: text, isHidden: models.count == 0)
    }
}
