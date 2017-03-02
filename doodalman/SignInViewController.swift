//
//  SignInViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 16..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

protocol SignInDelegate {
    func didSingIn()
}

class SignInViewController: UIViewController, SignInDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var delegate: SignInDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelSignIn(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func SignIn(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let email = self.email.text as AnyObject
        let password = self.password.text as AnyObject

        let parameters:[String: AnyObject] = ["email": email, "password": password]
        
        let model = DooDalMan.shared
        model.logIn(parameters) { (httpStatusCode, error) in
            
            if httpStatusCode == .Http404_NotFound {
                performUIUpdatesOnMain {
                    let alert = UIAlertController(title: "Not Found User", message: "Check email & password.", preferredStyle: UIAlertControllerStyle.alert)
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
    
    func didSingIn() {
        self.delegate?.didSingIn()
    }
    
    @IBAction func showSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "showSignUp", sender: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSignUp" {
            let signUpVC = segue.destination as! SignUpViewController
            signUpVC.delegate = self
        }
    }
    
}
