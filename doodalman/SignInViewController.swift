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

class SignInViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var delegate: SignInDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
