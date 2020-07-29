//
//  SearchLibraryViewController.swift
//  BookCoverViewer
//
//  Created by 植田圭祐 on 2020/07/04.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import SafariServices

class SearchLibraryViewController: UIViewController, LibraryDataSourceDelegate {
    
    func reloadTableView() {
        tableView.reloadData()
        
        //図書館の位置を表示するための地図
        libraryMap = MKMapView()
        libraryMap.frame = CGRect(x: 0, y: tableView.frame.maxY, width: view.frame.width, height: view.frame.height - tableView.frame.maxY)
        view.addSubview(libraryMap)
        
        //現在地を基準に領域を作成
        let lat = Double(nowLatitude!)
        let lng = Double(nowLongitude!)
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(lat!), CLLocationDegrees(lng!))
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        libraryMap.setRegion(region, animated: true)
        
        //地図にピンをさす
        for i in 0 ..< libraryDatabase.counter() {
            
            
            if let libraryInfo = libraryDatabase.getLibraryData(at: i) {
                print(libraryInfo.address)
                
                //住所を経度、緯度に変換
                CLGeocoder().geocodeAddressString(libraryInfo.address, completionHandler: { placeData, error in
                    guard let lat = placeData?.first?.location?.coordinate.latitude else {
                        print("Geocoder Error latitude")
                        return
                    }
                    
                    guard let lng = placeData?.first?.location?.coordinate.longitude else {
                        print("Geocoder Error longitude")
                        return
                    }
                    
                    //経度、緯度を指定してピンを作成
                    let markPoint = MKPointAnnotation()
                    markPoint.coordinate = CLLocationCoordinate2DMake(lat, lng)
                    markPoint.title = libraryInfo.name
                    markPoint.subtitle = libraryInfo.address
                    self.libraryMap.addAnnotation(markPoint)
                })
            }
        }
    }
    
    var nowLongitude: String!     //経度
    var nowLatitude: String!      //緯度
    var locationManager: CLLocationManager!
    var isbn: String!             //ISBN
    var tableView: UITableView!
    var libraryDatabase: LibraryDataSource!
    var libraryMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //図書館一覧を表示するTableView
        tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: view.frame.height * 0.4)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LibraryStatusCell.self, forCellReuseIdentifier: "bookCell")
        view.addSubview(tableView)
        
        //図書館情報の格納先
        libraryDatabase = LibraryDataSource()
        libraryDatabase.delegate = self

        
        //現在地取得
        setLocationManager()
        
        
        //図書館情報を取得
        libraryDatabase.getLibraryList(latitude: "35.54802649173376", longitude: "139.69526100551886")
        nowLatitude = "35.54802649173376"
        nowLongitude = "139.69526100551886"
        
        //蔵書状況を取得
        
        
        //表示
    }
    
    init(isbn: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.isbn = isbn
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //蔵書状況を取得
    func bookStatusSearch(libraryArray: [libraryData], isbn: String) {
        print("ISBN -> \(isbn)")
        
        let urlTop = "http://api.calil.jp/check?appkey=091d6652e5cc5d36486417c8484e487a&isbn=" + isbn + "&systemid="
        let urlBottom = "&format=json&callback="
        var systemIds: String = ""
        for book in libraryArray {
            systemIds = systemIds + book.systemid + ","
        }
        
        let requestURL = urlTop + systemIds + urlBottom
        print(requestURL)
    }

    
    func setLocationManager() {
        locationManager = CLLocationManager()
        
        //位置情報許可リクエスト
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        //位置情報許可ステータスを取得
        let status = CLLocationManager.authorizationStatus()
        
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10.0
            locationManager.startUpdatingLocation()
        }
    }
}

extension SearchLibraryViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        
        self.nowLatitude = String(latitude!)
        self.nowLongitude = String(longitude!)
        
        //searchLibraryData(latitude: nowLatitude, longitude: nowLongitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました")
    }
}


extension SearchLibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        libraryDatabase.counter()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell") as! LibraryStatusCell
        let libraryData = libraryDatabase.getLibraryData(at: indexPath.row)
        cell.libraryData = libraryData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlHeader = "https://calil.jp/library/"
        let libId = libraryDatabase.getLibraryData(at: indexPath.row)?.id
        let libName = libraryDatabase.getLibraryData(at: indexPath.row)?.name
        let requestURL = urlHeader + libId! + "/" + libName!
        print(requestURL)
        //let linkView = SFSafariViewController(url: )
    }
    
    
}
