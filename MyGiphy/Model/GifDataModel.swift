//
//  GifDataModel.swift
//  MyGiphy
//
//  Created by Abhishek Vasudev on 08/08/21.
//

import Foundation

struct Gif: Decodable, Equatable {
    static func == (lhs: Gif, rhs: Gif) -> Bool {
        lhs.id == rhs.id
    }
    let id: String
    let images: GifImages
}

struct GifImages: Decodable {
    let original: GifImage
    let downsized_large: GifImage
    let fixed_height: GifImage
}

struct GifImage: Decodable {
    let url: String
}

struct Pagination: Decodable {
    let total_count: Int
    let count: Int
    let offset: Int
}
