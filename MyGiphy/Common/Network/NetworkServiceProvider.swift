//
//  NetworkServiceProvider.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import Combine
import Foundation

protocol NetworkServiceProvider {
    associatedtype URNType

    func execute<URNType: URN>(with urnType: URNType) -> AnyPublisher<URNType.Derived, NetworkError>
    func downloadData(for url: URL) -> AnyPublisher<Data, NetworkError>
}
