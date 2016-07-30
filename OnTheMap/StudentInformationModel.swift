//
//  StudentInformationModel.swift
//  OnTheMap
//
//  Created by IT on 7/28/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import Foundation

let StudentInfoUpdatedNotification = "StudentInfoUpdatedNotification"
struct StudentInformationModel {
    
    // Student Location Creation Key
    static let createdAtKey = "createdAt"
    
    // First Name Key
    static let firstNameKey = "firstName"
    
    // Last Name Key
    static let lastNameKey = "lastName"
    
    // Latitude Key
    static let latitudeKey = "latitude"
    
    // Longitude Key
    static let longitudeKey = "longitude"
    
    // Map String Data Key
    static let mapStringKey = "mapString"
    
    // Student URL Key
    static let mediaURLKey = "mediaURL"
    // Object ID Key
    static let objectIdKey = "objectId"
    
    // Unique Key
    static let uniqueKeyKey = "uniqueKey"
    
    // Updated At Key
    static let updatedAtKey = "updatedAt"
    
    static var studs = [StudentInformation]()
    

    static func populateStudentList(withStudents newStudents: [[String: AnyObject]]) {
        studs.removeAll()
        
        for student1 in newStudents {
            let newStudent = StudentInformation(studInfo: student1)
            StudentInformationModel.studs.append(newStudent)
        }
        
        let note = NSNotification(name: StudentInfoUpdatedNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(note)
    }
}