//
//  ExamplesCVCell.swift
//  CounterApp
//
//  Created by Andres Acevedo on 09.01.2021.
//

import UIKit


final class ExamplesCVCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var containerView: UIView!
    
    static let reuseIdentifire = "ExamplesCVCell"
    
    // MARK: - Private Properies
    
    fileprivate var exampleName: String!
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Public Methods
    
    func configure(name: String) {
        exampleName = name
        setupUI()
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupUI() {
        containerView.layer.cornerRadius = AppConstants.appCornerRadius
        containerView.layer.masksToBounds = true
        titleLabel.text = exampleName
    }
}
