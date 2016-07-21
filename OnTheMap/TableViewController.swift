//
//  TableViewController.swift
//  OnTheMap
//
//  Created by IT on 7/20/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: - Constants
    
    let reuseIdentifier = "reusableCell"
    
    let returnActionTitle = "Return"
    let invalidLinkProvidedMessage = "Unable to open provided link!"
    let badLinkTitle = "Invalid URL"
    let parseRetrievalFailedTitle = "No Location Data"
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    

       
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return count of students from models
        // let numStudents = studentmodel.students.count
        return numStudents
    }
        

  

}
