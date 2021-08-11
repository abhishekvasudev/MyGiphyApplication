//
//  FavouriteViewController.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 05/08/21.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    private let rootView = UIView()
    private let favouriteTitleLabel = UILabel()
    private let gridCollectionViewCellIdentifier = "GridCollectionViewCell"
    private let gridCollectionViewContainerView = UIView()
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 50.0, right: 10.0)
    private let gridLayoutOptionsContainer = UIStackView()
    private let oneColumnButton = UIButton()
    private let twoColumnButton = UIButton()
    private let threeColumnButton = UIButton()
    
    private var gridCollectionView: UICollectionView!
    private var viewModel: FavouriteViewModel?
    private var itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRootView()
        setupFavouriteTitleLabel()
        setupGridLayoutOptionsContainer()
        setupGridOptionsButtons()
        setupGridCollectionViewContainer()
        setupGridCollectionView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.gridCollectionView.reloadData()
            self.viewModel?.checkForLatestData()
        }
    }
    
    private func setupRootView() {
        view.backgroundColor = MGColorScheme.lightBlue
        
        view.addSubview(rootView)
        rootView.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        constraints.append(rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(rootView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(rootView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
        rootView.backgroundColor = MGColorScheme.lightBlue
    }
    
    private func setupFavouriteTitleLabel() {
        rootView.addSubview(favouriteTitleLabel)
        
        favouriteTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        favouriteTitleLabel.numberOfLines = 0
        favouriteTitleLabel.textAlignment = .center
        var constraints: [NSLayoutConstraint] = []
        constraints = [
            favouriteTitleLabel.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 10),
            favouriteTitleLabel.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 40),
            rootView.trailingAnchor.constraint(equalTo: favouriteTitleLabel.trailingAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(constraints)
        favouriteTitleLabel.text = ""
    }
    
    private func setupGridLayoutOptionsContainer() {
        rootView.addSubview(gridLayoutOptionsContainer)
        gridLayoutOptionsContainer.axis = .horizontal
        gridLayoutOptionsContainer.spacing = 10
        gridLayoutOptionsContainer.distribution = .equalSpacing
        gridLayoutOptionsContainer.alignment = .fill
        gridLayoutOptionsContainer.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        constraints = [
            gridLayoutOptionsContainer.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 10),
            gridLayoutOptionsContainer.topAnchor.constraint(equalTo: favouriteTitleLabel.bottomAnchor, constant: 20),
            rootView.trailingAnchor.constraint(equalTo: gridLayoutOptionsContainer.trailingAnchor, constant: 10),
            gridLayoutOptionsContainer.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupGridOptionsButtons() {
        setupOneColumnButton()
        setupTwoColumnButton()
        setupThreeColumnButton()
    }
    
    private func setupOneColumnButton() {
        oneColumnButton.tintColor = MGColorScheme.favourite
        oneColumnButton.setTitle("One Column", for: .normal)
        let buttonBackgroundColor = UIColor.gray.withAlphaComponent(0.5)
        oneColumnButton.backgroundColor = buttonBackgroundColor
        oneColumnButton.layer.cornerRadius = 5
        oneColumnButton.addTarget(self, action: #selector(self.oneColumnButtonTapped), for: .touchUpInside)
        gridLayoutOptionsContainer.addArrangedSubview(oneColumnButton)
    }
    
    @objc private func oneColumnButtonTapped(_ sender:UIButton!) {
        itemsPerRow = 1
        gridCollectionView.reloadData()
    }
    
    private func setupTwoColumnButton() {
        twoColumnButton.tintColor = MGColorScheme.favourite
        twoColumnButton.setTitle("Two Columns", for: .normal)
        let buttonBackgroundColor = UIColor.gray.withAlphaComponent(0.5)
        twoColumnButton.backgroundColor = buttonBackgroundColor
        twoColumnButton.layer.cornerRadius = 5
        twoColumnButton.addTarget(self, action: #selector(self.twoColumnButtonTapped), for: .touchUpInside)
        gridLayoutOptionsContainer.addArrangedSubview(twoColumnButton)
    }
    
    @objc private func twoColumnButtonTapped(_ sender:UIButton!) {
        itemsPerRow = 2
        gridCollectionView.reloadData()
    }
    
    private func setupThreeColumnButton() {
        threeColumnButton.tintColor = MGColorScheme.favourite
        threeColumnButton.setTitle("Three Columns", for: .normal)
        let buttonBackgroundColor = UIColor.gray.withAlphaComponent(0.5)
        threeColumnButton.backgroundColor = buttonBackgroundColor
        threeColumnButton.layer.cornerRadius = 5
        threeColumnButton.addTarget(self, action: #selector(self.threeColumnButtonTapped), for: .touchUpInside)
        gridLayoutOptionsContainer.addArrangedSubview(threeColumnButton)
    }
    
    @objc private func threeColumnButtonTapped(_ sender:UIButton!) {
        itemsPerRow = 3
        gridCollectionView.reloadData()
    }
    
    private func setupGridCollectionViewContainer() {
        rootView.addSubview(gridCollectionViewContainerView)
        gridCollectionViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        gridCollectionViewContainerView.backgroundColor = .clear
        var constraints: [NSLayoutConstraint] = []
        constraints = [
            gridCollectionViewContainerView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 10),
            gridCollectionViewContainerView.topAnchor.constraint(equalTo: gridLayoutOptionsContainer.bottomAnchor, constant: 20),
            rootView.trailingAnchor.constraint(equalTo: gridCollectionViewContainerView.trailingAnchor, constant: 10),
            rootView.bottomAnchor.constraint(equalTo: gridCollectionViewContainerView.bottomAnchor, constant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupGridCollectionView() {
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = sectionInsets
        collectionViewLayout.scrollDirection = .vertical
        gridCollectionView = UICollectionView(frame: gridCollectionViewContainerView.frame,
                                              collectionViewLayout: collectionViewLayout)
        
        gridCollectionView?.register(GridCollectionViewCell.self,
                                     forCellWithReuseIdentifier: gridCollectionViewCellIdentifier)
        gridCollectionView?.backgroundColor = .clear
        
        gridCollectionView?.dataSource = self
        gridCollectionView?.delegate = self
        
        gridCollectionViewContainerView.addSubview(gridCollectionView)
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        constraints = [
            gridCollectionView.leadingAnchor.constraint(equalTo: gridCollectionViewContainerView.leadingAnchor),
            gridCollectionView.topAnchor.constraint(equalTo: gridCollectionViewContainerView.topAnchor),
            gridCollectionViewContainerView.trailingAnchor.constraint(equalTo: gridCollectionView.trailingAnchor),
            gridCollectionViewContainerView.bottomAnchor.constraint(equalTo: gridCollectionView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupViewModel() {
        if let tabBarController = self.tabBarController as? MGTabBarController {
            viewModel = FavouriteViewModel(dataStore: tabBarController.dataStore)
            viewModel?.delegate = self
            viewModel?.checkForLatestData()
        }
    }
}

extension FavouriteViewController: FavouriteViewModelDelegate {
    func updateFavouriteTitleLabel(with text: String) {
        favouriteTitleLabel.text = text
    }
    
    func updateGridCollectionView() {
        gridCollectionView.reloadData()
    }
}

extension FavouriteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if let gifs = viewModel?.getFavouriteGifs() {
            return gifs.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let gifs = viewModel?.getFavouriteGifs() else { return UICollectionViewCell.init() }
        let gifForCell = gifs[indexPath.row]
        let gifCell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCollectionViewCellIdentifier,
                                                         for: indexPath) as! GridCollectionViewCell
        gifCell.gif = gifForCell
        gifCell.viewModel = viewModel
        gifCell.load()
        return gifCell
    }
}

extension FavouriteViewController: UICollectionViewDelegate {}

extension FavouriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (sectionInsets.left + sectionInsets.right) * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
