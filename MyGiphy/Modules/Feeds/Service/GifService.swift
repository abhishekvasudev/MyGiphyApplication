//
//  GifService.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import Combine
import Foundation

protocol GifServiceProtocol {
    func getTrendingGifs(limit: Int, page: Int) -> AnyPublisher<GifResponse, NetworkError>
    func getSearchedGifs(searchQuery: String, limit: Int, page: Int) -> AnyPublisher<GifResponse, NetworkError>
}

class GifService<T: NetworkServiceProvider>: GifServiceProtocol {
    
    private var serviceProvider: T
    
    init(with serviceProvider: T) {
        self.serviceProvider = serviceProvider
    }
    
    func getTrendingGifs(limit: Int, page: Int) -> AnyPublisher<GifResponse, NetworkError> {
        
        let trendingGifsURN = TrendingGifsURN(limit: limit, offset: page)
        
        return serviceProvider.execute(with: trendingGifsURN)
            .map{ $0 }
            .eraseToAnyPublisher()
    }
    
    func getSearchedGifs(searchQuery: String, limit: Int, page: Int) -> AnyPublisher<GifResponse, NetworkError>  {
        
        let searchGifsURN = SearchGifsURN(query: searchQuery, limit: limit, offset: page)
        
        return serviceProvider.execute(with: searchGifsURN)
            .map{ $0 }
            .eraseToAnyPublisher()
    }
}
