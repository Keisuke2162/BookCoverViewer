//
//  GoogleBooksAPIModel.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/06/20.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation

struct BookModel: Codable {
    let kind: String
    let items: [Item]
}

struct Item: Codable {
    let kind: String
    let volumeInfo: volumeInfo
}

struct volumeInfo: Codable {
    let imageLinks: imageLinks?
}

struct imageLinks: Codable {
    let smallThumbnail: String
    let thumbnail: String
}
