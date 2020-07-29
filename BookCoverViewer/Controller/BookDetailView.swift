//
//  BookDetailView.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/06/28.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class BookDetailViewController: UIViewController {
    
    var bookData: BookCoverModel?
    
    var isFavorite: Bool = false
    var isbn: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let data = bookData else { return }
        
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.3)
        header.backgroundColor = .black
        view.addSubview(header)
        
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: view.frame.height * 0.2, height: view.frame.height * 0.2)
        imageView.center = header.center
        imageView.contentMode = .scaleAspectFit
        imageView.image = data.cover
        header.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: header.frame.maxY, width: view.frame.width * 0.9, height: view.frame.height * 0.1)
        titleLabel.text = data.title
        //titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        view.addSubview(titleLabel)
        
        let priceLabel = UILabel()
        priceLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: view.frame.width * 0.9, height: view.frame.height * 0.1)
        priceLabel.text = String(data.price)
        priceLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        view.addSubview(priceLabel)
        
        let autherLabel = UILabel()
        autherLabel.frame = CGRect(x: 0, y: priceLabel.frame.maxY, width: view.frame.width * 0.9, height: view.frame.height * 0.1)
        autherLabel.text = data.auther
        autherLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        view.addSubview(autherLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect(x: 0, y: autherLabel.frame.maxY, width: view.frame.width, height: view.frame.height * 0.2)
        descriptionLabel.text = data.discription
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        view.addSubview(descriptionLabel)
        
        let libraryButton = UIButton()
        libraryButton.frame = CGRect(x: view.frame.width * 0.1, y: view.frame.height * 0.8, width: view.frame.width * 0.1, height: view.frame.width * 0.1)
        libraryButton.setImage(UIImage(named: "library"), for: .normal)
        libraryButton.addTarget(self, action: #selector(TapedLibraryButton), for: .touchUpInside)
        view.addSubview(libraryButton)
        
        let amazonButton = UIButton()
        amazonButton.frame = CGRect(x: view.frame.width * 0.3, y: view.frame.height * 0.8, width: view.frame.width * 0.1, height: view.frame.width * 0.1)
        amazonButton.setImage(UIImage(named: "amazon"), for: .normal)
        view.addSubview(amazonButton)
        
        let starButton = UIButton()
        starButton.frame = CGRect(x: header.frame.width * 0.9, y: header.frame.height * 0.8, width: header.frame.width * 0.075, height: header.frame.width * 0.075)
        if isFavorite {
            starButton.setImage(UIImage(named: "star_gold"), for: .normal)
        } else {
            starButton.setImage(UIImage(named: "star_white"), for: .normal)
        }
        starButton.addTarget(self, action: #selector(TapedStarButton), for: .touchUpInside)
        header.addSubview(starButton)

    }
    
    init(isbn: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.isbn = isbn
        print(isbn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func TapedStarButton(_ sender: UIButton) {
        if isFavorite {
            sender.setImage(UIImage(named: "star_white"), for: .normal)
            isFavorite = false
        } else {
            sender.setImage(UIImage(named: "star_gold"), for: .normal)
            isFavorite = true
        }
    }
    
    //図書館ボタンを押下でカーリルへのリンク
    @objc func TapedLibraryButton(_ sender: UIButton) {
        
        let url = URL(string: "https://calil.jp/book/" + isbn)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
            
    
        
        /*
        let vc = SearchLibraryViewController(isbn: isbn)
        present(vc, animated: true, completion: nil)
        */
    }
}
