//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by IT on 7/11/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Handlers
    
    
    @IBAction func signInButtonPressed(sender: UIButton) {
        guard let username = usernameField.text, password = passwordField.text else {
            return
        }
        
        UdacityAPI.signInWithUsername(username, password: password) { (data, response, error) in
            
            if let error = error {
                // Network Error
                if error.code == NSURLErrorNotConnectedToInternet {
                    let alertController = UIAlertController(title: "", message: "Uh oh! Seems like you don't have an internet connection.", preferredStyle: .Alert)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [.AllowFragments]) as? [String:AnyObject] {
                        if (json["account"] as? [String:AnyObject]) != nil {
                            dispatch_async(dispatch_get_main_queue(), {
                                // present the Map And Table Tabbed View
                                
                                
                            })
                        } else {
                            // can't log in, invalid user. show UIAlertView or UIAlertController
                            let alertController = UIAlertController(title: "Incorrect Login", message: "The username and/or password may be incorrect", preferredStyle: .Alert)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                    
                } catch {
                    
                }
            }
        }
    }

}
