//
//  EndPoint.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import Foundation

enum EndPoint {
    case trending
    case search
    
    var rawValue: String {
        switch self {
        case .trending:
            return "/trending"
        case .search:
            return "/search"
        }
    }
}
