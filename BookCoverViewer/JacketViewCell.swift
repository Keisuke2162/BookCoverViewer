//
//  JacketViewCell.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/06/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class BookCoverCell: UICollectionViewCell {
    
    var jacketView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //contentView.backgroundColor = .yellow
        
        jacketView = UIImageView()
        contentView.addSubview(jacketView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        jacketView.frame = CGRect(x: 5, y: 5, width: contentView.frame.width - 5, height: contentView.frame.height - 5)
        jacketView.layer.cornerRadius = 1.0
        jacketView.clipsToBounds = true
        jacketView.contentMode = .scaleAspectFit
    }
    
    var bookData: BookCoverModel? {
        didSet {
            jacketView.image = bookData?.cover
        }
    }
    
}

class LibraryStatusCell: UITableViewCell {
    
    var libraryName: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
        
        libraryName = UILabel()
        contentView.addSubview(libraryName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        libraryName.frame = CGRect(x: 0, y: 0, width: contentView.frame.width / 2, height: contentView.frame.height)
    }
    
    var libraryData: LibraryDataModel? {
        didSet {
            libraryName.text = libraryData?.name
        }
    }
}
