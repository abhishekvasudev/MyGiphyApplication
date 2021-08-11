//
//  URLSessionProvider.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import Combine
import Foundation

struct URLSessionProvider: NetworkServiceProvider {
    typealias URNType = URN
    
    private let decoder = JSONDecoder()
    
    func execute<URNType>(with urnType: URNType) -> AnyPublisher<URNType.Derived, NetworkError> where URNType : URN {
        guard let request = urnType.getURLRequest() else {
            return Fail<URNType.Derived, NetworkError>(error: .urlRequestGenerationFailed).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                try self.validateResponse(for: response.response, data: response.data)
                return response.data
            }
            .decode(type: URNType.Derived.self, decoder: decoder)
            .mapError({ error -> NetworkError in
               if let networkError = error as? NetworkError {
                    return networkError
                }
                return .responseDecodingFailed
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func downloadData(for url: URL) -> AnyPublisher<Data, NetworkError> {
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { response -> Data in
                try self.validateResponse(for: response.response, data: response.data)
                return response.data
            }
            .mapError({ error -> NetworkError in
                return .responseDecodingFailed
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

private extension URLSessionProvider {
    func validateResponse(for response: URLResponse, data: Data) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.responseNotFound
        }
        // Giphy API sends 200 as success
        if response.statusCode != 200 {
            throw NetworkError.requestFailed(errorCode: response.statusCode, errorMessage: nil)
        }
    }
}
