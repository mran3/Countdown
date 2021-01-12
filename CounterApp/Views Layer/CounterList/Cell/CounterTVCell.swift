//
//  CounterTVCell.swift
//  CounterApp
//
//  Created by Andres Acevedo on 06.01.2021.
//

import UIKit

// MARK: - CounterCellDelegate

protocol CounterCellDelegate: class {
//    func updateModel(model: Counter)
    func increaseCounter(counterId: String)
    func decreaseCounter(counterId: String)
}

final class CounterTVCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var countLabel: UILabel!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var stepperView: UIStepper!
    
    static let reuseIdentifire = "CounterTVCell"
    
    // MARK: - Public Properies
    
    weak var delegate: CounterCellDelegate!
    var modelForSelection: Counter {
        return cellModel
    }
    
    // MARK: - Private Properies
    
    fileprivate var cellModel: Counter!
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        delegate = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor =  .clear
        self.selectedBackgroundView = bgColorView
    }
    
    // MARK: - Public Methods
    
    func configure(model: Counter) {
        setupUI()
        cellModel = model
        
        countLabel.text = String(model.count)
        countLabel.textColor = model.count == 0 ? AppColors.inactiveCountLabelColor.color : AppColors.mainTintColor.color
        nameLabel.text = model.title
        stepperView.value = Double(model.count)
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupUI() {
        self.tintColor = AppColors.mainTintColor.color
        containerView.layer.cornerRadius = AppConstants.appCornerRadius
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.02
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 16
    }
    
    // MARK: - IBAction
    
    @IBAction fileprivate func stepperAction(_ sender: Any) {
        let newValue = Int(stepperView.value)
        if newValue > cellModel.count {
            delegate.increaseCounter(counterId: cellModel.id)
        } else {
            delegate.decreaseCounter(counterId: cellModel.id)
        }
        countLabel.text = String(Int(stepperView.value))
        cellModel.count = Int(stepperView.value)
        countLabel.textColor = cellModel.count == 0 ? AppColors.inactiveCountLabelColor.color : AppColors.mainTintColor.color
    }
}
