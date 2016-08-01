//
//  TabBarController.swift
//  OnTheMap
//
//  Created by IT on 7/27/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Constants
    
    let logoutButtonTitle = "Logout"
    let pinImageName = "pin"
    let unwindFromLogoutButtonSegueID = "unwindFromLogoutButton"
    let tabBarPinToInfoPostingViewSegueID = "tabBarPinToInfoPostingViewSegue"
    
    
    // MARK: - Properties
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up navigation bar items
        navigationItem.title = "On The Map"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: logoutButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(doLogout))
        
        let pinButton = UIBarButtonItem(image: UIImage(named: pinImageName), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(postInformation))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(retrieveUserData))
        
        // note: right bar buttons in array appear on nav bar right to left
        navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateDataFailed), name: StudentInfoUpdateFailedNotification, object: nil)
        
        // do initial data call
        retrieveUserData()
        UdacityAPI.getUserInfo { (data, response, error) in
            
            if let error = error {
                self.presentAlert(error)
            }
            
            
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // refresh data when the view appears again
        retrieveUserData()
    }
    
    // MARK: - Selectors
    let badLinkMessage = "Uh oh! Seems like you don't have an internet connection."
    func updateDataFailed() {
        self.presentAlert("Update Failed", message: badLinkMessage, actionTitle: "OK")
    }
    
    /// Segues back (unwinds) to logout function
    func doLogout() {
        UdacityAPI.logOut()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /// Segues to Information Posting view
    func postInformation() {
        performSegueWithIdentifier(tabBarPinToInfoPostingViewSegueID, sender: nil)
    }
    
    
    /// Calls out for user information
    func retrieveUserData() {
        ParseAPI.retrieveMapData()
    }
    
}

