//
//  GoogleBooksAPIModel.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/06/20.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation

struct googleBooksModel: Codable {
    let kind: String
    let items: [Item]
}

struct Item: Codable {
    let kind: String
    let volumeInfo: volumeInfo
    let industryIdentifiers: [industryIdentifiers]?
}

struct volumeInfo: Codable {
    let imageLinks: imageLinks?
}

struct imageLinks: Codable {
    let smallThumbnail: String
    let thumbnail: String
}

struct industryIdentifiers: Codable {
    let type: String
    let identifier: String
}

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
            
            print(data)
            
            let json = try! JSONDecoder().decode(googleBooksModel.self, from: data.data(using: .utf8)!)
            print("ItemCount -> \(json.items.count)")
        })
        
        task.resume()
    }
}
