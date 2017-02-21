//
//  UserContactListViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 21..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import Nuke

class UserContactListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchContactList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchContactList() {
        let model = DooDalMan.shared
        
        model.fetchUesrContactList { contact, error in
            self.tableView.reloadData()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = DooDalMan.shared
        
        return model.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userContactCell", for: indexPath) as! UserContactTableViewCell
        
        let model = DooDalMan.shared
        
        let contact = model.contacts[indexPath.row]
        
        cell.thumbnail.image = nil
        Nuke.loadImage(with: URL(string: contact.thumbnail!)!, into: cell.thumbnail)
        cell.roomTitle.text = contact.title
        cell.lastChatContent.text = contact.contactChats?.last?.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = DooDalMan.shared
        
        self.performSegue(withIdentifier: "contact", sender: model.contacts[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contact" {
            let contactVC = segue.destination as! ContactViewController
            contactVC.contact = sender as? Contact
        }
    }
    
}
