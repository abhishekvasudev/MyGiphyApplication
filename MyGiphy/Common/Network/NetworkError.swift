//
//  NetworkError.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import Foundation

protocol MyGiphyAlertData {
    var alertTitle: String? {get}
    var alertMessage: String {get}
}

enum NetworkError: Error, MyGiphyAlertData, Equatable {
    
    case requestFailed(errorCode: Int, errorMessage: String?)
    case urlRequestGenerationFailed
    case responseDecodingFailed
    case responseNotFound
    
    var alertTitle: String? {
        "Network Error!"
    }
    
    static let requestFailedDefaultMessage = "An unexpected network error occurred! Please try later."
    
    var alertMessage : String {
        switch self {
        case .requestFailed( _, let errorMessage):
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                return errorMessage
            } else {
                return NetworkError.requestFailedDefaultMessage
            }
        default:
            return NetworkError.requestFailedDefaultMessage
        }
    }
}
