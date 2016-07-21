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
}
