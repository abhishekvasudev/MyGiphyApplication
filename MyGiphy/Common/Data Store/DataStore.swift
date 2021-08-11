//
//  DataStore.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import UIKit

class DataStore {
    
    private(set) var favouriteGifs: [Gif] = []
    private(set) var searchedGifs: [Gif] = []
    private(set) var trendingGifs: [Gif] = []
    private(set) var imageCache: [String: UIImage] = [:]
    
    func getImage(url: String) -> UIImage? {
        imageCache[url]
    }
    
    func saveImage(url: String, image: UIImage) {
        imageCache[url] = image
    }
    
    func setSearchedGifs(gifs: [Gif]) {
        searchedGifs = gifs
    }
    
    func appendSearchedGifs(gifs: [Gif]) {
        searchedGifs.append(contentsOf: gifs)
    }
    
    func setTrendingGifs(gifs: [Gif]) {
        trendingGifs = gifs
    }
    
    func appendTrendingGifs(gifs: [Gif]) {
        trendingGifs.append(contentsOf: gifs)
    }
    
    func isFavourite(gif: Gif) -> Bool {
        favouriteGifs.contains(where: { $0.id == gif.id })
    }
    
    func addFavourite(gif: Gif) {
        favouriteGifs.append(gif)
    }
    
    func removeFavourite(gif: Gif) {
        favouriteGifs.removeAll(where: { $0.id == gif.id })
    }
    
    func clearData() {
        searchedGifs.removeAll()
        trendingGifs.removeAll()
    }
}
