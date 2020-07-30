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
    var booksDataSource: BooksDataSource!
    var page = 1
    var searchWord = ""
    
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray
        
        print("AddTest")
        
        googleBookDataManagement = BookDataManagement_Google()
        rakutenBooksDataManagement = BooksDataManagement_Rakuten()
        booksDataSource = BooksDataSource()
        booksDataSource.delegate = self
        
        //メニューボタン
        let menuButton = UIButton()
        //menuButton.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        
        
        //検索バー実装
        searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 30, width: view.frame.width, height: view.frame.height * 0.1)
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.backgroundColor = .white
        view.addSubview(searchBar)
        
        //レイアウト定義
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        //layout.estimatedItemSize = CGSize(width: view.frame.width / 4, height: view.frame.width / 3)
        layout.itemSize = CGSize(width: view.frame.width / 4, height: view.frame.width / 3)
        
        //CollectionView定義
        collectionView = UICollectionView(frame: CGRect(x: 0, y: searchBar.frame.maxY, width: view.frame.width, height: view.frame.height - searchBar.frame.maxY),
                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BookCoverCell.self, forCellWithReuseIdentifier: "CollectionCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCollection), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        view.addSubview(collectionView)
    }
    
    @objc func refreshCollection(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        page += 1
        booksDataSource.getRakutenBooksList(word: searchWord, page: page)
        sender.endRefreshing()
    }
}

extension ViewController: UISearchBarDelegate {
    
    //キャンセル選択時
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    //検索ボタン押下時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            page = 1
            searchWord = text
            //googleBookDataManagement.apiRequest(str: text)
            //rakutenBooksDataManagement.apiRequest(str: text)
            booksDataSource.getRakutenBooksList(word: searchWord, page: page)
            searchBar.text = ""
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksDataSource.counter()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! BookCoverCell
        let bookData = booksDataSource.bookData(at: indexPath.row)
        cell.bookData = bookData
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveBookView(index: indexPath)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("スクロール終了")
        print(collectionView.visibleSize.height)
        let contentOffset = collectionView.contentOffset
        print(contentOffset)
    }
    
    func moveBookView(index: IndexPath) {
        let vc = BookDetailViewController(isbn: booksDataSource.bookData(at: index.row)!.isbn)
        vc.bookData = booksDataSource.bookData(at: index.row)
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: BooksDataSourceDelegate {
    func reloadCollectionView() {
        collectionView.reloadData()
        print("書籍件数 -> \(booksDataSource.counter())")
    }
}

