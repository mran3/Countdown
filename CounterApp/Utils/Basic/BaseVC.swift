//
//  BaseVC.swift
//  CounterApp
//
//  Created by Andres Acevedo on 06.01.2021.
//

import UIKit

// MARK: - BaseSetupProtocol

protocol BaseSetupProtocol: class {
    func setupVC()
    func setupUI()
}

class BaseVC: UIViewController, BaseSetupProtocol {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
        setupUI()
    }
    
    // MARK: - BaseSetupProtocol
    
    func setupVC() {}
    func setupUI() {}
}
