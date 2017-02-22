//
//  RoomTableViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 7..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import KFSwiftImageLoader

class RoomListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    var delegate: RoomDataDelegate?

    var rooms = [Room]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = DooDalMan.shared
//        return model.rooms.count
        return self.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomListCell", for: indexPath) as! RoomListTableViewCell
        
//        let model = DooDalMan.shared
//        cell.roomThumbnail.loadImage(urlString:model.rooms[indexPath.row].thumbnail!)
//        cell.roomTitle.text = model.rooms[indexPath.row].title
//        cell.roomAddresss.text = model.rooms[indexPath.row].full_addr
//        cell.roomPrice.text = model.rooms[indexPath.row].displayedPrice
//        cell.roomDate.text = model.rooms[indexPath.row].displayedDate
        
        cell.roomThumbnail.loadImage(urlString:self.rooms[indexPath.row].thumbnail!)
        cell.roomTitle.text = self.rooms[indexPath.row].title
        cell.roomAddresss.text = self.rooms[indexPath.row].full_addr
        cell.roomPrice.text = self.rooms[indexPath.row].displayedPrice
        cell.roomDate.text = self.rooms[indexPath.row].displayedDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = DooDalMan.shared
        self.performSegue(withIdentifier: "showRoom", sender: self.rooms[indexPath.row])
//        self.delegate?.showRoom(self.rooms[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoom" {
            let roomVC = segue.destination as! RoomViewController
            roomVC.room = sender as! Room
        }
    }
}
