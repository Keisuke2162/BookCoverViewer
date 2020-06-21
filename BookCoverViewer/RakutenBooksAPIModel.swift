//
//  RakutenBooksAPIModel.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/06/22.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation

struct BookModel_Rakuten: Codable {
    let count: Int
    let Items: [Items_R]
}

struct Items_R: Codable {
    let Item: Item_R
}

struct Item_R: Codable {
    let title: String
    let isbn: String
    let largeImageUrl: String
}
