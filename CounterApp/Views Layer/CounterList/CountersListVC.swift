//
//  ViewController.swift
//  CounterApp
//
//  Created by Andres Acevedo on 05.01.2021.
//

import UIKit

final class CountersListVC: BaseVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate weak var addNewCounerButton: UIButton!
    @IBOutlet fileprivate weak var errorView: ErrorView!
    @IBOutlet fileprivate weak var countersTableView: UITableView!
    @IBOutlet fileprivate weak var countOfCountersLabel: UILabel!
    @IBOutlet fileprivate weak var noResultLabel: UILabel!
    @IBOutlet fileprivate weak var removeCountersButton: UIButton!
    
    // MARK: - Private Variables
    
    fileprivate let counterListPresenter = CounterListPresenter(service: LocalCounterDataService())
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var editButton: UIBarButtonItem!
    fileprivate var doneButton: UIBarButtonItem!
    fileprivate var selectAllButton: UIBarButtonItem!
    fileprivate var searchBarItem: UISearchController!
    
    fileprivate var arrayForTableView: [Counter] = []
    fileprivate var isEditingMode = false {
        didSet {
            changeEditig(to: isEditingMode)
        }
    }
    
    fileprivate var models: [Counter] = [] {
        didSet {
            modelsDidChange(models: models)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        counterListPresenter.attachView(self)
        super.viewDidLoad()

        counterListPresenter.getCounters()
    }
    
    deinit {
        counterListPresenter.saveCounters(models)
        counterListPresenter.deatachView()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupVC() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
        
        setupButtons()
        setupNavBar()
        setupErrorView()
        setupTableView()
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupButtons() {
        removeCountersButton.setImage(#imageLiteral(resourceName: "trashImage"), for: .normal)
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        selectAllButton = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(selectAllTapped))
    }
    
    fileprivate func setupErrorView() {
        errorView.delegate = self
        errorView.configure(titleText: "No counters yet", subtitleText: "“When I started counting my blessings, my whole life turned around.”\n—Willie Nelson", buttonText: "Create a counter")
    }
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.tintColor = AppColors.mainTintColor.color
        searchBarItem = UISearchController(searchResultsController: nil)
        searchBarItem.searchResultsUpdater = self
        searchBarItem.obscuresBackgroundDuringPresentation = false
        searchBarItem.searchBar.searchTextField.clearButtonMode = .never
        searchBarItem.definesPresentationContext = true
        navigationItem.searchController = searchBarItem
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationItem.leftBarButtonItem = editButton
    }
    
    fileprivate func setupTableView() {
        countersTableView.delegate = self
        countersTableView.dataSource = self
        countersTableView.backgroundColor = .clear
        countersTableView.refreshControl = refreshControl
        countersTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        countersTableView.register(UINib.init(nibName: CounterTVCell.reuseIdentifire, bundle: nil), forCellReuseIdentifier: CounterTVCell.reuseIdentifire)
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    fileprivate func changeEditig(to mode: Bool) {
        countersTableView.setEditing(mode, animated: true)
        countOfCountersLabel.isHidden = mode
        removeCountersButton.isHidden = !mode
        searchBarItem.searchBar.isUserInteractionEnabled = !mode
        addNewCounerButton.setImage(mode ? #imageLiteral(resourceName: "shareImage") : #imageLiteral(resourceName: "addCounerImage"), for: .normal)
    }
    
    fileprivate func modelsDidChange(models: [Counter]) {
        let isEmpty = models.isEmpty
        errorView.isHidden = !isEmpty
        editButton.isEnabled = !isEmpty
        searchBarItem.searchBar.isUserInteractionEnabled = !isEmpty
        setupCountLabel()
    }
    
    fileprivate func setupCountLabel() {
        counterListPresenter.setupContersLabelText(for: models)
    }
    
    fileprivate func getSelectedCells() -> [Counter] {
        var selectedModels: [Counter] = []
        for section in 0 ..< countersTableView.numberOfSections {
            for row in 0 ..< countersTableView.numberOfRows(inSection: section) {
                guard let cell = countersTableView.cellForRow(at: IndexPath(row: row, section: section)) as? CounterTVCell else { continue }
                if cell.isSelected {
                    selectedModels.append(cell.modelForSelection)
                }
            }
        }
        return selectedModels
    }
    
    @objc fileprivate func editTapped() {
        isEditingMode = true
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = selectAllButton
    }
    
    @objc fileprivate func doneTapped() {
        isEditingMode = false
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc fileprivate func selectAllTapped() {
        for section in 0 ..< countersTableView.numberOfSections {
            for row in 0 ..< countersTableView.numberOfRows(inSection: section) {
                countersTableView.selectRow(at: IndexPath(row: row, section: section), animated: false, scrollPosition: .none)
            }
        }
    }
    
    @objc fileprivate func endEditingSearchBar() {
        navigationItem.searchController?.searchBar.endEditing(true)
    }
    
    @objc fileprivate func refreshData(_ sender: Any) {
        counterListPresenter.refreshData()
    }
    
    @objc fileprivate func saveData() {
        counterListPresenter.saveCounters(models)
    }
    
    // MARK: - IBActions
    
    @IBAction fileprivate func addButtonAction(_ sender: Any) {
        isEditingMode ? shareCounters() : openCreateVC()
    }
    
    @IBAction fileprivate func removeButtonAction(_ sender: Any) {
        removeSelectedCounters()
    }
}

// MARK: - Navigation

extension CountersListVC {
    fileprivate func openCreateVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateCounterVC") as! CreateCounterVC
        vc.counterDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func shareCounters() {
        let modelsToShare: [Counter] = getSelectedCells()
        counterListPresenter.shareSelectedCountersText(for: modelsToShare)
    }
    
    fileprivate func removeSelectedCounters() {
        let modelToDelete: [Counter] = getSelectedCells()
        
        guard modelToDelete.count > 0 else { return }
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete \(modelToDelete.count) counter", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.counterListPresenter.deleteCounters(allModels: strongSelf.models, modelsToDelete: modelToDelete)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CountersListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = countersTableView.dequeueReusableCell(withIdentifier: CounterTVCell.reuseIdentifire) as? CounterTVCell else { return UITableViewCell() }
        
        cell.configure(model: arrayForTableView[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

// MARK: - CountersListView

extension CountersListVC: CountersListView {
    func updateCountersArr(newArr: [Counter]) {
        models = newArr
    }
    
    func deleteCounters(_ newModelsArr: [Counter]) {
        doneTapped()
        models = newModelsArr
        arrayForTableView = newModelsArr
        countersTableView.reloadData()
    }
    
    func openShareController(textToShare: [String]) {
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [.mail, .copyToPasteboard, .message, .addToReadingList, .airDrop, .postToFacebook, .postToTwitter, .assignToContact]
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func setupCountersLabelText(text: String, isHidden: Bool) {
        countOfCountersLabel.isHidden = isHidden
        countOfCountersLabel.text = text
    }
    
    func setCounters(_ countes: [Counter]) {
        models = countes
        arrayForTableView = countes
        countersTableView.reloadData()
    }
}

// MARK: - CreateCounterDelegate

extension CountersListVC: CreateCounterDelegate {
    
    func refreshCounters() {
        counterListPresenter.getCounters()
    }
}

// MARK: - CounterCellDelegate

extension CountersListVC: CounterCellDelegate {
    func updateModel(model: Counter) {
        counterListPresenter.updateCounter(allModels: models, modelToUpdate: model)
    }
}

// MARK: - ErrorViewDelegate

extension CountersListVC: ErrorViewDelegate {
    func didPressMainbutton() {
        openCreateVC()
    }
}

// MARK: - UISearchResultsUpdating

extension CountersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        arrayForTableView = []
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            for model in models {
                model.title!.contains(searchText) ? arrayForTableView.append(model) : nil
            }
            noResultLabel.isHidden = arrayForTableView.count != 0
        } else {
            noResultLabel.isHidden = true
            arrayForTableView = models
        }
        countersTableView.reloadData()
    }
}
