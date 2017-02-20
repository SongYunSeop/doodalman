//
//  ContactListViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 19..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var room: Room?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchContactList()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = DooDalMan.shared
        
        
        return model.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = DooDalMan.shared
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactListCell", for: indexPath) as! ContactListTableViewCell
        
        cell.username.text = model.contacts[indexPath.row].username
        cell.content.text = model.contacts[indexPath.row].contactChats?.last?.content

        return cell
    }
    
    func fetchContactList() {
        let model = DooDalMan.shared
        model.fetchContactList(self.room!) { (result, error) in
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }
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
