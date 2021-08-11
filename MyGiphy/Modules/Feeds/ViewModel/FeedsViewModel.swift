//
//  FeedsViewModel.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import Combine
import UIKit

protocol FeedsViewModelDelegate: AnyObject {
    func updateSearchTitleLabel(with text: String)
    func updateTableView()
}

enum ViewState {
    case trending
    case feeds
}

class FeedsViewModel {
    
    private let dataStore: DataStore
    private let gifService: GifServiceProtocol
    
    private var subscriptions: Set<AnyCancellable> = []
    private var trendingPagination: Pagination
    private var searchPagination: Pagination
    private var viewState: ViewState
    private var searchQuery = ""
    private var isFetchInProgress = false
    
    weak var delegate: FeedsViewModelDelegate?
    
    init(dataStore: DataStore,
         gifService: GifServiceProtocol) {
        self.dataStore = dataStore
        self.gifService = gifService
        self.trendingPagination = Pagination(total_count: Int.max, count: 10, offset: 0)
        self.searchPagination = Pagination(total_count: Int.max, count: 10, offset: 0)
        self.viewState = .trending
        setup()
    }
    
    private func setup() {
        if dataStore.searchedGifs.isEmpty,
           dataStore.trendingGifs.isEmpty {
            delegate?.updateSearchTitleLabel(with: "Fetching Trending Gifs...")
            fetchTrendingGifs()
        }
    }
    
    func searchGifsButtonTapped(searchQuery: String) {
        clearData()
        if searchQuery.count > 1 {
            self.searchQuery = searchQuery
            self.viewState = .feeds
            fetchSearchedGifs()
        } else {
            self.viewState = .trending
            fetchTrendingGifs()
        }
    }
    
    private func clearData() {
        dataStore.clearData()
        delegate?.updateTableView()
    }
    
    private func fetchTrendingGifs() {
        if isFetchInProgress { return }
        isFetchInProgress = true
        gifService.getTrendingGifs(limit: trendingPagination.count, page: 0)
            .sink(receiveCompletion: { [weak self] _ in self?.isFetchInProgress = false },
                  receiveValue: { [weak self] gifResponse in
                    guard let self = self else { return }
                    self.trendingPagination = gifResponse.pagination
                    self.dataStore.setTrendingGifs(gifs: gifResponse.data)
                    self.delegate?.updateTableView()
                    self.delegate?.updateSearchTitleLabel(with: "Showing trending Gifs")
                  })
            .store(in: &subscriptions)
    }
    
    private func fetchSearchedGifs() {
        if searchQuery.count < 1 { return }
        if isFetchInProgress { return }
        isFetchInProgress = true
        gifService.getSearchedGifs(searchQuery: searchQuery,
                                     limit: searchPagination.count,
                                     page: 0)
            .sink(receiveCompletion: { [weak self] _ in
                guard let self = self else { return }
                self.isFetchInProgress = false
                self.delegate?.updateSearchTitleLabel(with: "Showing Gifs for \(self.searchQuery)")
                self.delegate?.updateTableView()
            },
                  receiveValue: { [weak self] gifResponse in
                    guard let self = self else { return }
                    self.searchPagination = gifResponse.pagination
                    self.dataStore.setSearchedGifs(gifs: gifResponse.data)
                    self.delegate?.updateTableView()
                  })
            .store(in: &subscriptions)
    }
    
    func fetchGifs() -> [Gif] {
        switch viewState {
        case .trending:
            return dataStore.trendingGifs
        case .feeds:
            return dataStore.searchedGifs
        }
    }
    
    func fetchMoreGifs() {
        switch viewState {
        case .trending:
            fetchMoreTrendingGifs()
        case .feeds:
            fetchMoreSearchedGifs()
        }
    }
    
    private func fetchMoreTrendingGifs() {
        if isFetchInProgress { return }
        isFetchInProgress = true
        if trendingPagination.count < trendingPagination.total_count {
            let nextPage = trendingPagination.offset + trendingPagination.count
            trendingPagination = Pagination(total_count: trendingPagination.total_count,
                                            count: trendingPagination.count,
                                            offset: nextPage)
        }
        
        gifService.getTrendingGifs(limit: trendingPagination.count, page: trendingPagination.offset)
            .sink(receiveCompletion: { [weak self] _ in self?.isFetchInProgress = false },
                  receiveValue: { [weak self] gifResponse in
                    guard let self = self else { return }
                    self.trendingPagination = gifResponse.pagination
                    self.dataStore.appendTrendingGifs(gifs: gifResponse.data)
                    self.delegate?.updateTableView()
                  })
            .store(in: &subscriptions)
    }
    
    private func fetchMoreSearchedGifs() {
        if isFetchInProgress { return }
        isFetchInProgress = true
        if searchQuery.count < 1 { return }
        if searchPagination.count < searchPagination.total_count {
            let nextPage = searchPagination.offset + searchPagination.count
            searchPagination = Pagination(total_count: searchPagination.total_count,
                                            count: searchPagination.count,
                                            offset: nextPage)
        }
        gifService.getSearchedGifs(searchQuery: searchQuery,
                                     limit: searchPagination.count,
                                     page: searchPagination.offset)
            .sink(receiveCompletion: { [weak self] _ in self?.isFetchInProgress = false },
                  receiveValue: { [weak self] gifResponse in
                    guard let self = self else { return }
                    self.searchPagination = gifResponse.pagination
                    self.dataStore.appendSearchedGifs(gifs: gifResponse.data)
                    self.delegate?.updateTableView()
                  })
            .store(in: &subscriptions)
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
    
    func isGifFavourite(gif: Gif) -> Bool {
        dataStore.isFavourite(gif: gif)
    }
    
    func addOrRemoveFavourite(gif: Gif) {
        if dataStore.isFavourite(gif: gif) {
            dataStore.removeFavourite(gif: gif)
        } else {
            dataStore.addFavourite(gif: gif)
        }
    }
}
