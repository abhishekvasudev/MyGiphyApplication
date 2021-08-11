//
//  FeedsViewModelTestSpecification.swift
//  MyGiphyTests
//
//  Created by Abhishek Vasudev on 09/08/21.
//

import XCTest
@testable import MyGiphy

class FeedsViewModelTestSpecification: XCTestCase {
    
    var viewModel: FeedsViewModel!
    var mockGifService: MockGifService!
    var dataStore = DataStore()

    override func setUp()  {
        mockGifService = MockGifService()
        viewModel = .init(dataStore: dataStore, gifService: mockGifService)
    }
    
    func testFetchTrendingGifsSetsTrendingGifsArray() {
        mockGifService.setSuccessResult()
        XCTAssertEqual(viewModel.fetchGifs(), dataStore.trendingGifs)
    }
    
    func testFetchTrendingGifsFailure() {
        mockGifService.setFailureResult(with: .responseNotFound)
        XCTAssertEqual(dataStore.trendingGifs, [])
    }
    
    func testFetchSearchedGifsSetsSearchedGifsArray() {
        viewModel.searchGifsButtonTapped(searchQuery: "Search")
        mockGifService.setSuccessResult()
        XCTAssertEqual(viewModel.fetchGifs(), dataStore.searchedGifs)
    }
    
    func testFetchSearchedGifsFailure() {
        viewModel.searchGifsButtonTapped(searchQuery: "Search")
        mockGifService.setFailureResult(with: .responseNotFound)
        XCTAssertEqual(dataStore.searchedGifs, [])
    }
    
    func testFetchOrAddImageSuccess() {
        let correctImageUrl = "https://media1.giphy.com/media/bo23SSRBTAG2GnuO1Q/200.gif"
        let image = viewModel.fetchOrAddImage(url: correctImageUrl)
        XCTAssertNotNil(image)
    }
    
    func testFetchOrAddImageFailure() {
        let incorrectImageUrl = ""
        let image = viewModel.fetchOrAddImage(url: incorrectImageUrl)
        XCTAssertNil(image)
    }
}
