//
//  TableViewController.swift
//  OnTheMap
//
//  Created by IT on 7/20/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Constants
    
    let reuseIdentifier = "locationCell"
    
    let returnActionTitle = "Return"
    let invalidLinkProvidedMessage = "Unable to open provided link!"
    let badLinkTitle = "Invalid URL"
    let parseRetrievalFailedTitle = "No Location Data"
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return count of students from models
        let numberOfStuds = StudentInformationModel.studs.count
        return numberOfStuds
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath:  indexPath)
        let studentInfo = StudentInformationModel.studs[indexPath.row]
        cell.textLabel?.text = "\(studentInfo.firstName) \(studentInfo.lastName)"
        cell.detailTextLabel?.text = "\(studentInfo.mediaURL)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        this object will check for applications that can open the provided URL
        let app = UIApplication.sharedApplication()
        
        //        make sure text is present in the cell and can be turned into a NSURL; if so, open it; else, alert and return!
        guard let providedURL = tableView.cellForRowAtIndexPath(indexPath)?.detailTextLabel?.text,
            let url = NSURL(string: providedURL) where app.openURL(url) == true else {
                
                let alertViewMessage = invalidLinkProvidedMessage
                let alertActionTitle = returnActionTitle
                
                presentAlert(badLinkTitle, message: alertViewMessage, actionTitle: alertActionTitle)
                return
        }
    }
}