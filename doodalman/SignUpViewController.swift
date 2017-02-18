//
//  SignUpViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 15..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelSignUp(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
//        var save = UserDefaults.standard
        // 키어쩌구

    }
    
    @IBAction func signUp(_ sender: UIButton) {

        let email = self.email.text as AnyObject
        let password = self.password.text as AnyObject
        let username = self.username.text as AnyObject
        
        let parameters:[String: AnyObject] = ["email": email, "password": password, "username": username ]
        let model = DooDalMan.shared
        
        model.signUp(parameters) { result, error in
            print("test")
        }
    }
    

}
