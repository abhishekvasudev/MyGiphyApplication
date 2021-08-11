//
//  URN.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol URN {
    associatedtype Derived: Decodable
    var apiKey: String { get }
    var endPoint: EndPoint { get }
    var baseURL: String { get }
    var queryPath: String? { get }
    var method: HTTPMethod { get }
    var parameters: [String: String]? { get }
    var body: Data? { get }
    var urlQueryItems: [URLQueryItem] { get }
    var headers: [String: String]? { get }
    func getURLRequest() -> URLRequest?
}

extension URN {
    
    var apiKey: String {
        "Od6uzEovNwnoI0146NdIWIbgBt4v2jDP"
    }
    
    var baseURL: String {
        "https://api.giphy.com/v1/gifs"
    }
    
    var queryPath: String? {
        return nil
    }
    
    var urlQueryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        if let parameters = parameters {
            for eachQueryParam in parameters {
                queryItems.append(URLQueryItem(name: eachQueryParam.key, value: eachQueryParam.value))
            }
        }
        return queryItems
    }
    
    func getURLRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL + endPoint.rawValue) else {
                return nil
        }
        urlComponents.queryItems = urlQueryItems
        
        guard let _url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: _url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.allowsConstrainedNetworkAccess = false
        request.allowsExpensiveNetworkAccess = true
        request.allowsCellularAccess = true
        return request
    }
}

protocol MyGiphyURN: URN {}

extension MyGiphyURN {
    
    var method: HTTPMethod {
        .get
    }
    
    var body: Data? {
        nil
    }
    
    var headers: [String : String]? {
        switch method {
        case .post, .put:
            return [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        default:
            return nil
        }
    }
    
    var parameters: [String: String]? {
        nil
    }
}

struct TrendingGifsURN: MyGiphyURN {

    typealias Derived = GifResponse
    var limit: Int = 10
    var offset: Int = 0
    
    var endPoint: EndPoint {
        .trending
    }
    
    var urlQueryItems: [URLQueryItem] {
        [URLQueryItem(name: "api_key", value: apiKey),
         URLQueryItem(name: "limit", value: "\(limit)"),
         URLQueryItem(name: "offset", value: "\(offset)")
        ]
    }
}

struct SearchGifsURN: MyGiphyURN {
    
    typealias Derived = GifResponse
    
    var query: String
    var limit: Int = 10
    var offset: Int = 0
    
    var endPoint: EndPoint {
        .search
    }
    
    var urlQueryItems: [URLQueryItem] {
        [URLQueryItem(name: "api_key", value: apiKey),
         URLQueryItem(name: "q", value: "\(query)"),
         URLQueryItem(name: "limit", value: "\(limit)"),
         URLQueryItem(name: "offset", value: "\(offset)")
        ]
    }
}
