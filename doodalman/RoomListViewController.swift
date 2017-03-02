//
//  RoomTableViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 7..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import Nuke

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
        return self.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomListCell", for: indexPath) as! RoomListTableViewCell
        
        
        cell.roomThumbnail.image = nil
        Nuke.loadImage(with: URL(string: self.rooms[indexPath.row].thumbnail!)!, into: cell.roomThumbnail)
        cell.roomPrice.text = self.rooms[indexPath.row].displayedPrice
        cell.roomDate.text = self.rooms[indexPath.row].displayedDate

        cell.roomAddresss.text = self.rooms[indexPath.row].full_addr
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showRoom", sender: self.rooms[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoom" {
            let roomVC = segue.destination as! RoomViewController
            roomVC.room = sender as! Room
        }
    }
}
