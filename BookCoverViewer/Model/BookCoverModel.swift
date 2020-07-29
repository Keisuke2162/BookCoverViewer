//
//  BookCoverModel.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/06/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

//本を表示する形式

import Foundation
import UIKit

protocol BooksDataSourceDelegate {
    func reloadCollectionView()
}

class BookCoverModel: NSObject {
    
    let title: String
    let cover: UIImage
    let auther: String
    let price: Int
    let discription: String
    let isbn: String
    
    init(bookTitle: String, bookCover: String, bookAuther: String, bookCaption: String, bookPrice: Int, bookIsbn: String) {
        title = bookTitle
        cover = UIImage(url: bookCover)
        auther = bookAuther
        price = bookPrice
        discription = bookCaption
        isbn = bookIsbn
    }
}

class BooksDataSource: NSObject {
    
    var books = [BookCoverModel]()
    var rakutenBooks = BooksDataManagement_Rakuten()
    var delegate: BooksDataSourceDelegate?
    
    func getRakutenBooksList(word: String, page: Int) {
        //APIでデータ取得
        rakutenBooks.apiRequest(str: word,page: page, success: { bookList in
            //取得正常時
            if page == 1 {
                self.books = []
            }
            
            //BookCoverModelに変換
            for data in bookList {
                let book = BookCoverModel.init(bookTitle: data.Item.title, bookCover: data.Item.largeImageUrl, bookAuther: data.Item.author, bookCaption: data.Item.itemCaption, bookPrice: data.Item.itemPrice, bookIsbn: data.Item.isbn)
                self.books.append(book)
            }
            
            if let delegate = self.delegate {
                delegate.reloadCollectionView()
            }
        })
    }
    
    func counter() -> Int {
        return books.count
    }
    
    func bookData(at index: Int) -> BookCoverModel? {
        if books.count > index {
            return books[index]
        }
        return nil
    }
}


//URLを画像に変換
extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
