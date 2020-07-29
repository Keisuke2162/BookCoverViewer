//
//  LibraryDataModel.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/07/04.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation

struct libraryModel: Codable {
    let libarary: [libraryData]
}

struct libraryData: Codable {
    let city: String
    let short: String
    let systemid: String
    let address: String
    let libid: String
    let url_pc: String
}

class LibraryDataModel: NSObject {
    let name: String
    let address: String
    let id: String
    
    init(libraryName: String, libraryAddress: String, libraryId: String) {
        name = libraryName
        address = libraryAddress
        id = libraryId
    }
}

protocol LibraryDataSourceDelegate {
    func reloadTableView()
}

class LibraryDataSource: NSObject {
    
    var librarys = [LibraryDataModel]()
    var delegate: LibraryDataSourceDelegate?
    
    func getLibraryList(latitude: String, longitude: String) {
        searchLibraryData(latitude: latitude, longitude: longitude, success: { librarysData in
            for library in librarysData {
                let data = LibraryDataModel.init(libraryName: library.short, libraryAddress: library.address, libraryId: library.libid)
                self.librarys.append(data)
            }
            
            if let delegate = self.delegate {
                delegate.reloadTableView()
            }
        })
    }
    
    func counter() -> Int {
        return librarys.count
    }
    
    func getLibraryData(at index: Int) -> LibraryDataModel? {
        if librarys.count > index {
            return librarys[index]
        }
        return nil
    }
    
    
    
    //近くの図書館を検索してAPIの配列情報を返却
    func searchLibraryData(latitude: String, longitude: String, success: @escaping ([libraryData]) -> Void) {
        print("図書館の検索処理に移行します")
        
        let urlHeader = "https://api.calil.jp/library?appkey=091d6652e5cc5d36486417c8484e487a&geocode="
        let urlFooter = "&limit=5&format=json&callback="
        let locate = urlHeader + longitude + "," + latitude + urlFooter
        //let encodingURL = locate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let requestURL = URL(string: locate)!
        print(locate)
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: requestURL, completionHandler: { (data, response, error) in
            
            guard let data = String(data: data!, encoding: .utf8) else {
                print("Error")
                return
            }
            
            print(data)
            DispatchQueue.main.async {
                let json = try! JSONDecoder().decode([libraryData].self, from: data.data(using: .utf8)!)
                print(json)
                success(json)
            }
        })
        task.resume()
    }
}


//蔵書検索モデル
struct collectionBookModel: Codable {
    let session: String
    let `continue`: Int
    
}
/*
struct bookModel {
    
}
*/
