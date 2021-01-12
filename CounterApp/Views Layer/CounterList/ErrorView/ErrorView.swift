//
//  ErrorView.swift
//  CounterApp
//
//  Created by Andres Acevedo on 05.01.2021.
//

import UIKit

// MARK: - ErrorViewDelegate

protocol ErrorViewDelegate: class {
    func didPressMainbutton()
}

final class ErrorView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel: UILabel!
    @IBOutlet fileprivate weak var mainButton: UIButton!
    
    // MARK: - Public Variables
    
    weak var delegate: ErrorViewDelegate!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    // MARK: - Public Methods
    
    func configure(titleText: String, subtitleText: String, buttonText: String) {
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
        mainButton.setTitle(buttonText, for: .normal)
        mainButton.layer.cornerRadius = AppConstants.appCornerRadius
    }
    
    // MARK: - Private Methods
    
    fileprivate func commonInit() {
        let bundle = Bundle(for: ErrorView.self)
        bundle.loadNibNamed(String(describing: ErrorView.self), owner: self, options: nil)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - IBActions
    
    @IBAction func mainButtonAction(_ sender: Any) {
        delegate.didPressMainbutton()
    }
}
