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
    
    var delegate: SignInDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }

    @IBAction func cancelSignUp(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {

        let email = self.email.text as AnyObject
        let password = self.password.text as AnyObject
        let username = self.username.text as AnyObject
        
        let parameters:[String: AnyObject] = ["email": email, "password": password, "username": username ]
        let model = DooDalMan.shared
        
        model.signUp(parameters) { httpStatusCode, error in
            if httpStatusCode == .Http400_BadRequest {
                performUIUpdatesOnMain {
                    let alert = UIAlertController(title: "이미 가입된 Email 주소입니다.", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            } else if httpStatusCode == .Http200_OK {
                performUIUpdatesOnMain {
                    self.delegate?.didSingIn()
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        }
    }
    

}
