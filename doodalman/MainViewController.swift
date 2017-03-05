//
//  ViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 6..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import MapKit
import FontAwesome_swift

class MainViewController: UIViewController, FilterViewDelegate, RoomDataDelegate {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var roomCountLabel: UILabel!
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    @IBOutlet weak var userButton: UIBarButtonItem!
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var listContainerView: UIView!
    
    var mapViewController: MapViewController?
    var roomListViewController: RoomListViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialUI()
    }

    // UI set
    func setInitialUI() {
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        self.filterButton.setTitleTextAttributes(attributes, for: .normal)
        self.filterButton.title = String.fontAwesomeIcon(name: .filter)
        self.toggleButton.setTitleTextAttributes(attributes, for: .normal)
        self.toggleButton.title = String.fontAwesomeIcon(name: .list)
        self.userButton.setTitleTextAttributes(attributes, for: .normal)
        self.userButton.title = String.fontAwesomeIcon(name: .user)
        
    }
    
    // 방 정보가 로드되었을때 호출되는 함수
    func roomLoaded() {
        let model = DooDalMan.shared
        self.roomCountLabel?.text = "\(model.rooms.count) 개의 방"
//        if let mapView = self.mapViewController?.mapView {

//        }
        roomListViewController?.rooms = model.rooms

        if let tableView = self.roomListViewController?.tableView {
            
            tableView.reloadData()
        }
    }
    
    // Filter Delegate
    // 필터가 저장되면 다시 정보를 불러오는 함수
    func filterSaved() {
        self.mapViewController?.fetchRoomData()

    }
    
    func showRoom(_ room: Room) {
        performSegue(withIdentifier: "showRoom", sender: room)
    }
    
    // 필터 띄우는 액션
    @IBAction func showFilter(_ sender: UIBarButtonItem) {
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "DDMFilter") as! DDMFilterViewController
//        filterVC.delegate = self
        self.present(filterVC, animated: true, completion: nil)
    }
    

    @IBAction func showUser(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showUser", sender: sender)
    }
    
    // 화면 전환(맵 뷰 & 테이블 뷰)
    @IBAction func toggleView(_ sender: UIBarButtonItem) {
        
        if mapContainerView.alpha == 0 {
            self.toggleButton.title = String.fontAwesomeIcon(name: .list)

            UIView.animate(withDuration: 0.5, animations: {
                self.mapContainerView.alpha = 1
                self.listContainerView.alpha = 0
            })
        } else {
            self.toggleButton.title = String.fontAwesomeIcon(name: .mapO)

            UIView.animate(withDuration: 0.5, animations: {
                self.mapContainerView.alpha = 0
                self.listContainerView.alpha = 1
            })
        }
        
    }
    
    // prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomList" {
            self.roomListViewController = segue.destination as? RoomListViewController
            self.roomListViewController?.delegate = self
            
        } else if segue.identifier == "MapView" {
            self.mapViewController = segue.destination as? MapViewController
            self.mapViewController?.delegate = self
        } else if segue.identifier == "showRoom" {
            let RoomVC = segue.destination as! RoomViewController
            RoomVC.room = sender as! Room
        }
    }
    

}


