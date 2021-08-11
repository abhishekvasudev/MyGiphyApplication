//
//  FavouriteViewModel.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import UIKit

protocol FavouriteViewModelDelegate: AnyObject {
    func updateFavouriteTitleLabel(with text: String)
    func updateGridCollectionView()
}

class FavouriteViewModel {
    private let dataStore: DataStore
    
    weak var delegate: FavouriteViewModelDelegate?
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore 
    }
    
    func checkForLatestData() {
        if dataStore.favouriteGifs.isEmpty {
            delegate?.updateFavouriteTitleLabel(with: "Oops! Looks like you haven't added any favourites! Go back to Feeds Tab and add some gifs in your favourites and watch them here.")
        } else {
            let count = dataStore.favouriteGifs.count
            delegate?.updateFavouriteTitleLabel(with: "You have \(count) favourite gifs")
        }
    }
    
    func getFavouriteGifs() -> [Gif] {
        dataStore.favouriteGifs
    }
    
    func removeFavourite(gif: Gif) {
        dataStore.removeFavourite(gif: gif)
        delegate?.updateGridCollectionView()
    }
    
    func fetchOrAddImage(url: String) -> UIImage? {
        if let image = dataStore.getImage(url: url) {
            return image
        }
        
        if let image = UIImage.gif(url: url) {
            dataStore.saveImage(url: url, image: image)
            return image
        }
        return nil
    }
}
