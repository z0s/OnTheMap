//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by IT on 7/18/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import Foundation

typealias RequestCompletionHandler = (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void

struct UdacityAPI {
    
    static let url = NSURL(string: "https://www.udacity.com/api/session")
    static let session = NSURLSession.sharedSession()
    
    static func signInWithUsername(username: String, password: String, completion: RequestCompletionHandler?) -> Void {
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if error != nil {
                if let completion = completion {
                    completion(data: nil, response: nil, error: error)
                }
                return
            }
            guard let data = data else {
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            if let completion = completion {
                completion(data: newData, response: response, error: error)
            }
        }
        
        task.resume()
    }
    
    static func getUserInfo() {
        //User.uniqueKey = "3487088640"
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(User.uniqueKey)")!)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
            guard let data = data else {
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(newData, options: [.AllowFragments]) as? [String:AnyObject] {
                    
                    print("userInfoJSON = ", json)
                    
                    if let userDict = json["user"] as? [String:AnyObject] {
                        User.firstName = userDict["first_name"] as! String
                        User.lastName = userDict["last_name"] as! String
                    }
                }
            } catch let error {
                print(error)
            }
            print(response)
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
}
