//
//  ExamplesTVCell.swift
//  CounterApp
//
//  Created by Andres Acevedo on 09.01.2021.
//

import UIKit

// MARK: - CounterCellDelegate

protocol ExamplesCellDelegate: class {
    func closeWithName(name: String)
}

final class ExamplesTVCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var exampleCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    static let reuseIdentifier = "ExamplesTVCell"
    
    // MARK: - Public Properies
    
    weak var delegate: ExamplesCellDelegate!
    
    // MARK: - Private Properies
    
    fileprivate var cellModel: ExamplesModels!
    
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
    
    func configure(model: ExamplesModels) {
        cellModel = model
        setupUI()
        setupCollectionView()
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupCollectionView() {
        exampleCollectionView.delegate = self
        exampleCollectionView.dataSource = self
        exampleCollectionView.backgroundColor = .clear
        if let layout = exampleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            exampleCollectionView.collectionViewLayout = layout
        }
        
        exampleCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        exampleCollectionView.register(UINib.init(nibName: ExamplesCVCell.reuseIdentifire, bundle: nil), forCellWithReuseIdentifier: ExamplesCVCell.reuseIdentifire)
    }
    
    fileprivate func setupUI() {
        self.tintColor = AppColors.mainTintColor.color
        titleLabel.text = cellModel.title.uppercased()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ExamplesTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModel.countersName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = exampleCollectionView.dequeueReusableCell(withReuseIdentifier: ExamplesCVCell.reuseIdentifire, for: indexPath) as? ExamplesCVCell else { return UICollectionViewCell() }
        
        cell.configure(name: cellModel.countersName[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.closeWithName(name: cellModel.countersName[indexPath.row])
    }
}
