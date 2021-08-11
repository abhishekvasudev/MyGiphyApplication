//
//  MockGifService.swift
//  MyGiphyTests
//
//  Created by Abhishek Vasudev on 09/08/21.
//

import Combine
import Foundation
@testable import MyGiphy

final class MockGifService: GifServiceProtocol {
    
    var result: Result<GifResponse, NetworkError> = .failure(.responseNotFound)
    
    func getTrendingGifs(limit: Int, page: Int) -> AnyPublisher<GifResponse, NetworkError> {
        return result.publisher.eraseToAnyPublisher()
    }
    
    func getSearchedGifs(searchQuery: String, limit: Int, page: Int) -> AnyPublisher<GifResponse, NetworkError> {
        return result.publisher.eraseToAnyPublisher()
    }
    
    func setSuccessResult() {
        result = .success(getMockGifResponse())
    }
    
    func setFailureResult(with error: NetworkError) {
        result = .failure(error)
    }
    
    private func getMockGifResponse() -> GifResponse {
        let mockGifImage = GifImage(url: "mockUrl")
        let mockGif = Gif(id: "mockGif",
                          images: GifImages(original: mockGifImage,
                                            downsized_large: mockGifImage,
                                            fixed_height: mockGifImage))
        return GifResponse(data: [mockGif],
                           pagination: Pagination(total_count: 0, count: 0, offset: 0))
    }
}
