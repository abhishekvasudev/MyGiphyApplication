//
//  GifTableViewCell.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 07/08/21.
//

import Combine
import UIKit

class GifTableViewCell: UITableViewCell {
    
    var gif: Gif?
    var viewModel: FeedsViewModel?
    
    private var subscription: Set<AnyCancellable> = []
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
        setupGifImageView()
        setupFavouriteButton()
    }
    
    private func setupGifImageView() {
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.image = UIImage.gif(name: "LoadingGif")
        gifImageView.layer.shadowColor = UIColor.black.cgColor
        gifImageView.layer.shadowOpacity = 0.5
        gifImageView.layer.shadowRadius = 10
        gifImageView.layer.shadowOffset = CGSize.zero
    }
    
    private func setupFavouriteButton() {
        favouriteButton.tintColor = MGColorScheme.favourite
        let buttonBackgroundColor = UIColor.gray.withAlphaComponent(0.5)
        favouriteButton.backgroundColor = buttonBackgroundColor
        favouriteButton.layer.cornerRadius = 5
    }
    
    func loadImage() {
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
        
        if let gif = gif, let viewModel = viewModel {
            if viewModel.isGifFavourite(gif: gif) {
                favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func favouriteButtonAction(_ sender: UIButton) {
        if let gif = gif, let viewModel = viewModel {
            viewModel.addOrRemoveFavourite(gif: gif)
            if viewModel.isGifFavourite(gif: gif) {
                favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
}
