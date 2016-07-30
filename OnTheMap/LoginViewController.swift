//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by IT on 7/11/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    let invalidLinkMessage = "Uh oh! Seems like you don't have an internet connection."
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer()
        tapOutKeyboard()
        // Do any additional setup after loading the view.
        
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:20, height:10))
        usernameField.leftViewMode = UITextFieldViewMode.Always
        usernameField.leftView = spacerView
        
        let anotherSpacerView = UIView(frame:CGRect(x:0, y:0, width:20, height:10))
        passwordField.leftViewMode = UITextFieldViewMode.Always
        passwordField.leftView = anotherSpacerView
        
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func gradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [orange.bOrange.CGColor as CGColorRef, orange.aOrange.CGColor as CGColorRef]
        gradient.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    
    // MARK: - Handlers
    
    
    @IBAction func signInButtonPressed(sender: UIButton) {
        dismissKeyboard()
        
        guard let username = usernameField.text, password = passwordField.text else {
            return
        }
        
        let spinner = showSpinner()
        UdacityAPI.signInWithUsername(username, password: password) { (data, response, error) in
            spinner.hide()
            if let error = error {
                // Network Error
                if error.code == NSURLErrorNotConnectedToInternet {
                    
                    let alertViewMessage = self.invalidLinkMessage
                    let okActionAlertTitle = "OK"
                    
                    self.presentAlert("Not Online", message: alertViewMessage, actionTitle: okActionAlertTitle, actionHandler: nil)
                    
                }
            } else {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [.AllowFragments]) as? [String:AnyObject] {
                        if let accountDict = json["account"] as? [String:AnyObject] {
                            User.uniqueKey = accountDict["key"] as! String
                            dispatch_async(dispatch_get_main_queue(), {
                                // present the Map And Table Tabbed View
                                if let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarNavController") {
                                    self.presentViewController(tabBarVC, animated: true, completion: nil)
                                }
                            })
                        } else {
                            // can't log in, invalid user. show UIAlertView or UIAlertController
                            self.presentAlert("Incorrect Login", message: "The username and/or password may be incorrect", actionTitle: "OK")
                        }
                    }
                    
                } catch {
                    
                }
            }
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        _ = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController")
        UIApplication.sharedApplication().openURL(NSURL(string: url.URL)!)
    }
    struct url {
        static let URL = "https://www.udacity.com/account/auth#!/signup"
    }
    
    struct orange {
        static let aOrange = UIColor(red:0.99, green:0.44, blue:0.13, alpha:1.00)
        static let bOrange = UIColor(red:0.99, green:0.60, blue:0.16, alpha:1.00)
    }
    
    // MARK: - TextField Delegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
}
