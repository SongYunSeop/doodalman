//
//  UserTableViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 21..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController, SignInDelegate {

    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var contactCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let model = DooDalMan.shared
        
        if model.authToken != nil {
            self.fetchUserInfo()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = DooDalMan.shared
        
        if model.authToken == nil {
            if indexPath.section == 0 && indexPath.row == 1 {
                return 0
            }
            if indexPath.section == 3 && indexPath.row == 1 {
                return 0
            }
            if indexPath.section == 2 && indexPath.row == 1 {
                return 0
            }
        } else {
            if indexPath.section == 0 && indexPath.row == 0 {
                return 0
            }
            if indexPath.section == 3 && indexPath.row == 0 {
                return 0
            }

            if let hasRoom = model.userInfo?.hasRoom! {
                if hasRoom {
                    if indexPath.section == 2 && indexPath.row == 0 {
                        return 0
                    }

                } else {
                    if indexPath.section == 2 && indexPath.row == 1 {
                        return 0
                    }

                }
            }
        
            
        }
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 || indexPath.section == 3{
            if indexPath.row == 0 {
                self.signIn()

            } else {
                self.logOut()
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.recentRooms()
            } else if indexPath.row == 1 {
                self.likeRooms()
            } else if indexPath.row == 2 {
                self.contactRooms()
            }
            
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                self.addRoom()
            } else {
                self.showMyRoom()
            }
            
        }
    }
    
    func fetchUserInfo() {
        let model = DooDalMan.shared
        
        model.fetchUserInfo { result, error in
            performUIUpdatesOnMain {
                print("succ")
                if let userInfo = model.userInfo {
                    if let likeCount = userInfo.likeRooms?.count {
                        self.likeCountLabel.text = "\(likeCount)"
                    }
                    
                    if let contactCount = userInfo.contactRooms?.count {
                        self.contactCountLabel.text = "\(contactCount)"
                    }
                }
                self.tableView.reloadData()
            }
            
        }
    }
    
    func signIn() {        
        let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "signinview") as! SignInViewController
        let navigationController = UINavigationController(rootViewController: signInVC)

        signInVC.delegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func logOut() {
        let model = DooDalMan.shared
        model.logOut {
            performUIUpdatesOnMain {
                let alert = UIAlertController(title: "로그아웃 되었습니다.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { alert in
                    self.tableView.reloadData()
                }
                alert.addAction(okAction)
                self.likeCountLabel.text = ""
                self.contactCountLabel.text = ""
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    func didSingIn() {
        self.fetchUserInfo()
//        self.tableView.reloadData()
    }
    
    
    func recentRooms() {
        print("recent Room")
    }
    
    
    func likeRooms() {
        let model = DooDalMan.shared
        
        if model.authToken == nil {
            self.signIn()
        } else {
            self.performSegue(withIdentifier: "RoomList", sender: model.userInfo?.likeRooms)
        }
    }

    func contactRooms() {
        let model = DooDalMan.shared
        
        if model.authToken == nil {
            self.signIn()
        } else {
            self.performSegue(withIdentifier: "RoomList", sender: model.userInfo?.contactRooms)
        }
    }
    
    func showMyRoom() {
        let model = DooDalMan.shared
        
        if model.authToken == nil {
            self.signIn()
        } else {
            self.performSegue(withIdentifier: "showRoom", sender: model.userInfo?.myRoom)
            
        }
    }
    
    func addRoom() {
        let model = DooDalMan.shared
        
        if model.authToken == nil {
            self.signIn()
        } else {
            self.performSegue(withIdentifier: "AddRoom", sender: 1)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomList" {
            let roomListVC = segue.destination as! RoomListViewController
            roomListVC.rooms = sender as! [Room]
        } else if segue.identifier == "showRoom" {
            let roomVC = segue.destination as! RoomViewController
            roomVC.room = sender as! Room
        }
    }
}
