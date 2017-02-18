//
//  ChatViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 17..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import SocketIO

class ContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var socket: SocketIOClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let model = DooDalMan.shared
        self.connectSocketIO()
    }
    
    func connectSocketIO() {
        let model = DooDalMan.shared

        self.socket = SocketIOClient(socketURL: URL(string: "http://omsh.ga")!, config: [.log(false), .forcePolling(false), .path("/io/")])
        self.socket?.connect()
        self.socket?.joinNamespace("/room/\(model.contactClient?.contactId!)")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = DooDalMan.shared
        
        return (model.contactClient?.contactChats!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = DooDalMan.shared
        
        let chat = model.contactClient?.contactChats?[indexPath.row]
        
        if (chat?.isMe!)! {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userChatCell", for: indexPath) as! ContactTableViewCell
            cell.contentTextView?.text = chat?.content
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "anotherUserChatCell", for: indexPath) as! ContactTableViewCell
            cell.contentTextView?.text = chat?.content

            return cell

        }
//
//        let model = DooDalMan.shared
//        cell.roomThumbnail.loadImage(urlString:model.rooms[indexPath.row].thumbnail!)
//        cell.roomTitle.text = model.rooms[indexPath.row].title
//        cell.roomAddresss.text = model.rooms[indexPath.row].full_addr
//        cell.roomPrice.text = model.rooms[indexPath.row].displayedPrice
//        cell.roomDate.text = model.rooms[indexPath.row].displayedDate
    }

}
