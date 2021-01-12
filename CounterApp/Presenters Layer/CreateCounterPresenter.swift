//
//  CreateCounterPresenter.swift
//  CounterApp
//
//  Created by Andres Acevedo on 12.01.2021.
//

import UIKit

// MARK: - CreateCounterView

protocol CreateCounterView: class {
    func setupExamplesLabel(attributedText: NSAttributedString)
    func closeVCandRefresh()
    func showAlert()
}

class CreateCounterPresenter {
    
    // MARK: - Private Properties
    
    weak fileprivate var createCounterView: CreateCounterView!
    
    // MARK: - Lifecycle
    
    init() {}
    
    func attachView(_ createCounterView: CreateCounterView) {
        self.createCounterView = createCounterView
    }
    
    func deatachView() {
        self.createCounterView = nil
    }
    
    func setupExampleText() {
        let fullText = "Give it a name. Creative block? See examples."
        let underlineText = "examples."
        let underlineRange = NSRange(fullText.range(of: underlineText)!, in: fullText)
        let fullRange = NSMakeRange(0, fullText.count)
        let attributedText = NSMutableAttributedString(string: fullText)
        attributedText.addAttributes([.font: UIFont.systemFont(ofSize: 15, weight: .regular),
                                      .foregroundColor: AppColors.darkSilverColor.color], range: fullRange)
        attributedText.addAttribute(.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: underlineRange)
        createCounterView.setupExamplesLabel(attributedText: attributedText)
    }
    
    func createCounter(name: String) {
        let remoteService = RemoteCounterService()
        remoteService.createCounter(title: name) {
            [weak self] result in
            switch result {
            case .failure:
                print("error occured")
                self?.createCounterView.showAlert()
            case.success:
                print("counter created")
                self?.createCounterView.closeVCandRefresh()
            }
            
        }
    }
}
