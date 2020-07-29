//
//  HomeTabbarController.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/07/14.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit

class HomeTabbarController: UITabBarController, UITabBarControllerDelegate {
    
    let conSearchBookView = ViewController()
    
    private lazy var searchBookViewController: ViewController = {
        
        let item = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        conSearchBookView.tabBarItem = item
        
        return conSearchBookView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let views: [UIViewController] = [searchBookViewController]
        setViewControllers(views, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //let tabbatHeight = self.tabBar.frame.height
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
