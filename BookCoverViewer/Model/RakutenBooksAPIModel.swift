//
//  RakutenBooksAPIModel.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/06/22.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation

struct rakutenBooksModel: Codable {
    let count: Int
    let Items: [Items_R]
}

struct Items_R: Codable {
    let Item: Item_R
}

struct Item_R: Codable {
    let title: String
    let author: String
    let isbn: String
    let itemCaption: String
    let itemPrice: Int
    let largeImageUrl: String
}

class BooksDataManagement_Rakuten: NSObject {
    
    let urlHeader = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&title="
    let urlPage = "&sort=sales&page="
    let urlFooter = "&applicationId=1023733360269357986"
    
    func apiRequest(str: String, page: Int, success: @escaping ([Items_R]) -> Void){
        let requestStr = urlHeader + str + urlPage + String(page) + urlFooter
        let encodingStr = requestStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let requestUrl = URL(string: encodingStr)!
        print(requestUrl)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: requestUrl, completionHandler: { (data, response, error) in
            
            guard let data = String(data: data!, encoding: .utf8) else {
                print("Error")
                return
            }
            
            DispatchQueue.main.async {
                let json = try! JSONDecoder().decode(rakutenBooksModel.self, from: data.data(using: .utf8)!)
                
                for i in json.Items {
                    print(i.Item.largeImageUrl)
                }
                success(json.Items)
            }
        })
        task.resume()
    }
}
