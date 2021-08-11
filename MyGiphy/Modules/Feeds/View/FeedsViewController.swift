//
//  FeedsViewController.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 05/08/21.
//

import UIKit


class FeedsViewController: UIViewController {
    
    private let searchButtonImage = UIImage(systemName: "magnifyingglass")
    private let gifTableViewCellIdentifier = "GifTableViewCell"
    
    private var viewModel: FeedsViewModel?
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRootView()
        setupSearchTextField()
        setupSearchButton()
        setupSearchTitleLabel()
        setupTableView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupRootView() {
        view.backgroundColor = MGColorScheme.lightBlue
        rootView.backgroundColor = MGColorScheme.lightBlue
    }
    
    private func setupSearchTextField() {
        searchTextField.placeholder = "Search Gif"
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                          style: UIBarButtonItem.Style.done,
                                                          target: self,
                                                          action: #selector(keyBoardToolBarDoneButtonAction))
        
        let doneToolbarItems = [flexSpace, doneButton]
        
        doneToolbar.items = doneToolbarItems
        doneToolbar.sizeToFit()
        
        self.searchTextField.inputAccessoryView = doneToolbar
    }
    
    @objc
    private func keyBoardToolBarDoneButtonAction() {
        self.searchTextField.resignFirstResponder()
    }
    
    private func setupSearchButton() {
        searchButton.setImage(searchButtonImage, for: .normal)
        searchButton.tintColor = .white
        searchButton.backgroundColor = MGColorScheme.darkBlue
        searchButton.layer.cornerRadius = 5
    }
    
    private func setupSearchTitleLabel() {
        searchTitleLabel.textAlignment = .center
        searchTitleLabel.numberOfLines = 0
    }
    
    private func setupTableView() {
        tableView.allowsMultipleSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupViewModel() {
        if let tabBarController = self.tabBarController as? MGTabBarController {
            self.viewModel = FeedsViewModel(dataStore: tabBarController.dataStore,
                                             gifService: GifService(with: tabBarController.urlSessionProvider))
            self.viewModel?.delegate = self
        }
    }
    
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        if let searchQuery = searchTextField.text {
            viewModel?.searchGifsButtonTapped(searchQuery: searchQuery)
        }
    }
}

extension FeedsViewController: FeedsViewModelDelegate {
    func updateSearchTitleLabel(with text: String) {
        searchTitleLabel.text = text
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FeedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let gifs = viewModel?.fetchGifs() {
            return gifs.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let gifs = viewModel?.fetchGifs() else { return UITableViewCell.init() }
        
        
        if indexPath.row == gifs.count - 1 {
            viewModel?.fetchMoreGifs()
        }
        
        let gifForCell = gifs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: gifTableViewCellIdentifier,
                                                 for: indexPath) as! GifTableViewCell
        cell.gif = gifForCell
        cell.viewModel = viewModel
        cell.loadImage()
        return cell
    }
}

extension FeedsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
