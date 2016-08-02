//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by IT on 7/29/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import Foundation

let StudentInfoUpdateFailedNotification = "StudentInfoUpdateFailedNotification"

struct ParseAPI {
    static let url = NSURL(string: "https://api.parse.com/1/classes/StudentLocation")
    static let session = NSURLSession.sharedSession()
    
    static func retrieveMapData() -> Void {
        let urlComponents = NSURLComponents(string: url!.absoluteString)
        urlComponents?.queryItems = [NSURLQueryItem(name: "limit", value: "100"), NSURLQueryItem(name: "order", value: "-updatedAt")]
        
        guard let urlWithParams = urlComponents?.URL else {
            return
        }
        
        
        let request = NSMutableURLRequest(URL: urlWithParams)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let response = response as? NSHTTPURLResponse {
                if response.statusCode < 200 || response.statusCode > 300 {
                    let note = NSNotification(name: StudentInfoUpdateFailedNotification, object: nil)
                    NSNotificationCenter.defaultCenter().postNotification(note)
                    return
                }
            }
            if error != nil {
                let note = NSNotification(name: StudentInfoUpdateFailedNotification, object: nil)
                NSNotificationCenter.defaultCenter().postNotification(note)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments]) as? [String:AnyObject] {
                    if let studentInfoArray = json["results"] as? [[String:AnyObject]] {
                        StudentInformationModel.populateStudentList(withStudents: studentInfoArray)
                    } else {
                    }
                }
                
            } catch {
                
            }
            
            
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            // Parse data and create local model objects with the data, and then send an NSNotification to the rest of the app that the data was downloaded
        }
        
        task.resume()
    }
    
    static func postUserLocation(completion: RequestCompletionHandler?) {
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyString = "{\"uniqueKey\": \"\(User.uniqueKey)\", \"firstName\": \"\(User.firstName)\", \"lastName\": \"\(User.lastName)\",\"mapString\": \"\(User.mapString)\", \"mediaURL\": \"\(User.mediaURL)\",\"latitude\": \(User.latitude), \"longitude\": \(User.longitude)}"
        
        print("bodyString = ", bodyString)
        
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        print("request = ", request)
        
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if let completion = completion {
                completion(data: data, response: response, error: error)
            }
        }
        task.resume()
    }
}
