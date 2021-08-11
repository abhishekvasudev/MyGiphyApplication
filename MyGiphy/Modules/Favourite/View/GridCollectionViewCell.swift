//
//  GridCollectionViewCell.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    let gifImageView = UIImageView()
    let favouriteButton = UIButton()
    var gif: Gif?
    var viewModel: FavouriteViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupGifImageView()
        setupFavouriteButton()
    }
    
    private func setupGifImageView() {
        addSubview(gifImageView)
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        gifImageView.backgroundColor = .clear
        var constraints: [NSLayoutConstraint] = []
        constraints = [
            gifImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gifImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: gifImageView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupFavouriteButton() {
        addSubview(favouriteButton)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.addTarget(self, action: #selector(self.favouriteButtonTapped), for: .touchUpInside)
        favouriteButton.tintColor = MGColorScheme.favourite
        let buttonBackgroundColor = UIColor.gray.withAlphaComponent(0.5)
        favouriteButton.backgroundColor = buttonBackgroundColor
        favouriteButton.layer.cornerRadius = 5
        favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        var constraints: [NSLayoutConstraint] = []
        constraints = [
            self.trailingAnchor.constraint(equalTo: favouriteButton.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: favouriteButton.bottomAnchor),
            favouriteButton.heightAnchor.constraint(equalToConstant: 20),
            favouriteButton.widthAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    func load() {
        gifImageView.image = UIImage.gif(name: "LoadingGif")
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageUrl = self.gif?.images.fixed_height.url,
               let image = self.viewModel?.fetchOrAddImage(url: imageUrl) {
                DispatchQueue.main.async {
                    self.gifImageView.image = image
                    self.layoutSubviews()
                }
            }
        }
    }
    
    @objc private func favouriteButtonTapped(_ sender:UIButton!) {
        if let gif = gif, let viewModel = viewModel {
            viewModel.removeFavourite(gif: gif)
            viewModel.checkForLatestData()
        }
    }
}
