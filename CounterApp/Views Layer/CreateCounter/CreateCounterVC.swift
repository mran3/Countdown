//
//  CreateCounterVC.swift
//  CounterApp
//
//  Created by Andres Acevedo on 05.01.2021.
//

import UIKit

// MARK: - CreateCounterDelegate

protocol CreateCounterDelegate: class {
//    func appendCounter(model: Counter)
    func refreshCounters()
}

final class CreateCounterVC: BaseVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var counterTextFieldContainer: UIView!
    @IBOutlet fileprivate weak var counterNameTextField: UITextField!
    @IBOutlet fileprivate weak var saveActivityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var examplesLabel: UILabel!
    
    // MARK: - Private Properties
    
    fileprivate let createCounterPresenter = CreateCounterPresenter()
    fileprivate var leftButton: UIBarButtonItem!
    fileprivate var rightButton: UIBarButtonItem!
    
    // MARK: - Public Properties
    
    weak var counterDelegate: CreateCounterDelegate!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        createCounterPresenter.attachView(self)
        super.viewDidLoad()
        
    }
    
    deinit {
        createCounterPresenter.deatachView()
    }
    
    override func setupVC() {
        navigationItem.largeTitleDisplayMode = .never
        
        leftButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTapped))
        rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.title = "Create a counter"
    }
    
    override func setupUI() {
        view.backgroundColor = AppColors.backgroundColor.color
        
        setupTextFieldContainer()
        setupNameTextField()
        setupExamplesLabel()
        setupTaps()
        saveActivityIndicator.isHidden = true
        rightButton.isEnabled = false
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupTextFieldContainer() {
        counterTextFieldContainer.layer.cornerRadius = AppConstants.appCornerRadius
        counterTextFieldContainer.clipsToBounds = false
        counterTextFieldContainer.layer.shadowColor = UIColor.black.cgColor
        counterTextFieldContainer.layer.shadowOpacity = 0.02
        counterTextFieldContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        counterTextFieldContainer.layer.shadowRadius = 16
    }
    
    fileprivate func setupNameTextField() {
        counterNameTextField.placeholder = "Cups of coffee"
        counterNameTextField.tintColor = AppColors.mainTintColor.color
        counterNameTextField.autocapitalizationType = .words
        counterNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    fileprivate func setupExamplesLabel() {
        createCounterPresenter.setupExampleText()
    }
    
    fileprivate func setupTaps() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openExamplesTapped))
        examplesLabel.isUserInteractionEnabled = true
        examplesLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func closeTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func openExamplesTapped() {
        openExamplesVC()
    }

    @objc fileprivate func saveTapped() {
        saveActivityIndicator.isHidden = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        counterNameTextField.isEnabled = false
        createCounterPresenter.createCounter(name: counterNameTextField.text ?? "")
    }
    
    @objc fileprivate func textFieldDidChange(_ textField: UITextField) {
        rightButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
}

// MARK: - Navigation

extension CreateCounterVC {
    fileprivate func openExamplesVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ExamplesVC") as! ExamplesVC
        vc.examplesDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CreateCounterView

extension CreateCounterVC: CreateCounterView {
    
    func closeVCandRefresh() {
        counterDelegate.refreshCounters()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.closeTapped()
        })
    }
    
    func setupExamplesLabel(attributedText: NSAttributedString) {
        examplesLabel.attributedText = attributedText
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Couldn't create the counter", message: "The Internet connection appears to be offline.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            self.closeTapped()
        }))

        self.present(alert, animated: true)
        
    }
}

// MARK: - ExamplesDelegate

extension CreateCounterVC: ExamplesDelegate {
    func createCounter(name: String) {
        counterNameTextField.text = name
        saveTapped()
    }
}
