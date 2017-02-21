//
//  UserTableViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 21..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController, SignInDelegate {
    
    @IBOutlet weak var authCell: UITableViewCell!
    @IBOutlet weak var logOutCell: UITableViewCell!
    
    @IBOutlet weak var recentRoomCell: UITableViewCell!
    @IBOutlet weak var likeRoomCell: UITableViewCell!
    
//    @IBOutlet weak var signInButton: UIButton!
//    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        self.checkAuth()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section), row: \(indexPath.row)")
        
        if indexPath.section == 0 || indexPath.section == 3{
            if indexPath.row == 0 {
                self.signIn()

            } else {
                self.logOut()
            }
        } else if indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
            
        } 

        
    }
    
    func signIn() {
        let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "signinview") as! SignInViewController
        signInVC.delegate = self
        self.present(signInVC, animated: true, completion: nil)
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
                
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = DooDalMan.shared
        
        if model.authToken == nil {
            if indexPath.section == 0 && indexPath.row == 1 {
                return 0
            }
            if indexPath.section == 3 && indexPath.row == 1 {
                return 0
            }
        } else {
            if indexPath.section == 0 && indexPath.row == 0 {
                return 0
            }
            if indexPath.section == 3 && indexPath.row == 0 {
                return 0
            }
        }
        
        return 44
    }
    
    
    func didSingIn() {
        self.tableView.reloadData()
    }

}
