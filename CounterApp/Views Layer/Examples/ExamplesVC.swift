//
//  ExamplesVC.swift
//  CounterApp
//
//  Created by Andres Acevedo on 08.01.2021.
//

import UIKit

// MARK: - ExamplesDelegate

protocol ExamplesDelegate: class {
    func createCounter(name: String)
}

final class ExamplesVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var examplesTableView: UITableView!
    
    // MARK: - Public Variables
    
    weak var examplesDelegate: ExamplesDelegate!
    
    // MARK: - Private Variables
    
    fileprivate let examplePresenter = ExamplePresenter()
    fileprivate var examplesModels: [ExamplesModels] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        examplePresenter.attachView(self)
        super.viewDidLoad()
    }
    
    deinit {
        examplePresenter.deatachView()
    }
    
    override func setupVC() {
        setupNavBar()
        fillExampleModelsArr()
        setupTableView()
    }
    
    override func setupUI() {
        view.backgroundColor = AppColors.backgroundColor.color
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupNavBar() {
        setupBackButton()
        
        navigationController?.navigationBar.tintColor = AppColors.mainTintColor.color
        navigationItem.title = "Examples"
    }
    
    fileprivate func setupBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
        backButton.setTitle("Create", for: .normal)
        backButton.setTitleColor(AppColors.mainTintColor.color, for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.frame = CGRect(x: 0.0, y: 0.0, width: 68, height: 20.0)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
    }
    
    fileprivate func fillExampleModelsArr() {
        examplePresenter.fillArrData()
    }
    
    fileprivate func setupTableView() {
        examplesTableView.delegate = self
        examplesTableView.dataSource = self
        examplesTableView.backgroundColor = .clear
        examplesTableView.estimatedRowHeight = UITableView.automaticDimension
        examplesTableView.rowHeight = 115
        examplesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        examplesTableView.register(UINib.init(nibName: ExamplesTVCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ExamplesTVCell.reuseIdentifier)
    }
    
    @objc fileprivate func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ExamplesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examplesModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = examplesTableView.dequeueReusableCell(withIdentifier: ExamplesTVCell.reuseIdentifier) as? ExamplesTVCell else { return UITableViewCell() }
        
        cell.configure(model: examplesModels[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

// MARK: - ExampleView

extension ExamplesVC: ExampleView {
    func fillArrForTV(models: [ExamplesModels]) {
        examplesModels = models
        examplesTableView.reloadData()
    }
}

// MARK: - CounterCellDelegate

extension ExamplesVC: ExamplesCellDelegate {
    func closeWithName(name: String) {
        examplesDelegate.createCounter(name: name)
        navigationController?.popViewController(animated: true)
    }
}
