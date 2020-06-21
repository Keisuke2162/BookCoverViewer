//
//  ViewController.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/06/20.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var searchBar: UISearchBar!
    var googleBookDataManagement: BookDataManagement_Google!
    var rakutenBooksDataManagement: BooksDataManagement_Rakuten!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray
        
        googleBookDataManagement = BookDataManagement_Google()
        rakutenBooksDataManagement = BooksDataManagement_Rakuten()
        
        //検索バー実装
        searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 30, width: view.frame.width, height: view.frame.height * 0.1)
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.backgroundColor = .white
        view.addSubview(searchBar)
    }
}

extension ViewController: UISearchBarDelegate {
    
    //キャンセル選択時
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    //検索ボタン押下時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            //print(text)
            //googleBookDataManagement.apiRequest(str: text)
            rakutenBooksDataManagement.apiRequest(str: text)
            searchBar.text = ""
        }
    }
}

