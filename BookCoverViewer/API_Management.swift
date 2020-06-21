//
//  API_Management.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/06/20.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class BookDataManagement_Google: NSObject {
    
    let urlHearder = "https://www.googleapis.com/books/v1/volumes?q="
    let urlFooter = "&maxResults=5&startIndex=0"
    
    func apiRequest(str: String) {
        let requestStr = urlHearder + str + urlFooter
        let encodingStr = requestStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let requestUrl = URL(string: encodingStr)!
        print(requestUrl)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: requestUrl, completionHandler: { (data, response, error) in
            
            guard let data = String(data: data!, encoding: .utf8) else {
                print("Error")
                return
            }
            
            let json = try! JSONDecoder().decode(BookModel.self, from: data.data(using: .utf8)!)
            print("ItemCount -> \(json.items.count)")
            
            for i in json.items {
                if let image = i.volumeInfo.imageLinks {
                    print(image.thumbnail)
                }
            }
        })
        
        task.resume()
    }
}

class BooksDataManagement_Rakuten: NSObject {
    
    let urlHeader = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&title="
    let urlFooter = "&applicationId=1023733360269357986"
    
    func apiRequest(str: String) {
        let requestStr = urlHeader + str + urlFooter
        let encodingStr = requestStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let requestUrl = URL(string: encodingStr)!
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: requestUrl, completionHandler: { (data, response, error) in
            
            guard let data = String(data: data!, encoding: .utf8) else {
                print("Error")
                return
            }
            
            let json = try! JSONDecoder().decode(BookModel_Rakuten.self, from: data.data(using: .utf8)!)
            print("書籍件数 -> \(json.count)")
            print(json)
            for i in json.Items {
                print(i.Item.title)
            }
            
        })
        
        task.resume()
    }
}
