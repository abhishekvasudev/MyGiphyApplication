//
//  GiphResponse.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import Foundation

struct GifResponse: Decodable {
    let data: [Gif]
    let pagination: Pagination
}
