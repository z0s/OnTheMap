//
//  MapViewController.swift
//  OnTheMap
//
//  Created by IT on 7/27/16.
//  Copyright © 2016 z0s. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    let invalidURL = "Invalid URL."
    
    let invalidLinkMessage = "Sorry the link provided is invalid."
    let reuseId = "reusableAnnotationPin"
    let returnTitle = "Return"
   
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(studentInfoUpdated), name: StudentInfoUpdatedNotification, object: nil)
        studentInfoUpdated()
    }
    
    func studentInfoUpdated() {
        let students = StudentInformationModel.studs
        // We will create an MKPointAnnotation for each student in "students". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for student in students {
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            // When the array is complete, we add the annotations to the map.
            self.mapView.addAnnotations(annotations)
        }
    }

    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            
            guard let providedURL = view.annotation?.subtitle where providedURL != nil,
                
                let url1 = NSURL(string: providedURL!) where app.openURL(url1) == true else {
                    
                    let alertViewMessage = invalidLinkMessage
                    let alertActionTitle = returnTitle
                    
                    presentAlert(invalidURL, message: alertViewMessage, actionTitle: alertActionTitle)
                    
                    return
            }
            
            }
            
        }
    }
    

