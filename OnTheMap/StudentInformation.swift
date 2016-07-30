//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by IT on 7/28/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import Foundation


struct StudentInformation {
    
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
    
    init(studInfo: [String: AnyObject]) {
        createdAt = studInfo[StudentInformationModel.createdAtKey] != nil ? studInfo[StudentInformationModel.createdAtKey] as! String : ""
        firstName = studInfo[StudentInformationModel.firstNameKey] as! String
        lastName  = studInfo[StudentInformationModel.lastNameKey]  as! String
        latitude  = studInfo[StudentInformationModel.latitudeKey]  as! Double
        longitude = studInfo[StudentInformationModel.longitudeKey] as! Double
        mapString = studInfo[StudentInformationModel.mapStringKey] as! String
        mediaURL  = studInfo[StudentInformationModel.mediaURLKey]  as! String
        objectId  = studInfo[StudentInformationModel.objectIdKey] != nil ? studInfo[StudentInformationModel.objectIdKey] as! String : ""
        uniqueKey = studInfo[StudentInformationModel.uniqueKeyKey] as! String
        updatedAt = studInfo[StudentInformationModel.updatedAtKey] != nil ? studInfo[StudentInformationModel.updatedAtKey] as! String : ""
    }
    
    
}