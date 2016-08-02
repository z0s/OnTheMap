//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by IT on 7/27/16.
//  Copyright © 2016 z0s. All rights reserved.
//
import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var submitLinkButton: UIButton!
    @IBOutlet weak var buttonBackgroundView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelButton: UIButton!
    
    let geoCodeError = "Failed to geocode String!"
    
    var activityIndicator: UIActivityIndicatorView?
    var coords : CLPlacemark?
    
    override func viewDidLoad() {
        linkTextView.delegate = self
        self.locationTextView.delegate = self
        self.linkTextView.alpha = 0
        self.submitLinkButton.hidden = true
        tapOutKeyboard()
        linkTextView.returnKeyType = .Done
        locationTextView.returnKeyType = .Done
    }
    @IBAction func findOnTheMapButtonPressed(sender: AnyObject) {
        
        let locationtext = locationTextView.text
        User.mapString = locationtext!
        self.activityIndicator = showSpinner()
        CLGeocoder().geocodeAddressString(locationtext!) { (placemarks, error) in
            if error != nil {
                self.presentAlert(self.geoCodeError, message: "Please try another address", actionTitle: "OK")
                print()
                self.activityIndicator?.hide()
            } else if placemarks!.count > 0 {
                self.activityIndicator?.hide()
                let placemark = placemarks![0] as CLPlacemark
                self.coords = placemark
                self.showMap()
            } else {
                self.activityIndicator?.hide()
                self.presentAlert(self.geoCodeError, message: "No placemarks returned", actionTitle: "OK")
                
            }
        }
    }
    
    private func showMap() {
        //1. Hide TextField
        UIView.animateWithDuration(0.5) {
            self.titleLabel.hidden = true
            self.locationTextView.alpha = 0.0
            self.findOnTheMapButton.alpha = 0
            self.submitLinkButton.hidden = false
            self.findOnTheMapButton.enabled = false
            self.linkTextView.alpha = 1
            self.view.backgroundColor = self.locationTextView.backgroundColor
            self.cancelButton.titleLabel?.textColor = UIColor.whiteColor()
        }
        
        let place = MKPlacemark(placemark: self.coords!)
        
        
        self.mapView.addAnnotation(place)
        
        let region = MKCoordinateRegionMakeWithDistance((place.location?.coordinate)!, 5000.0, 7000.0)
        
        mapView.setRegion(region, animated: true)
    }
    
    //4. Submit Button
    @IBAction func submitLinkButtonPressed(sender: AnyObject) {
        
        User.latitude = (self.coords!.location?.coordinate.latitude)!
        User.longitude = (self.coords!.location?.coordinate.longitude)!
        User.mediaURL = self.linkTextView.text!
        
        activityIndicator = showSpinner()
        ParseAPI.postUserLocation { (data, response, error) in
            self.activityIndicator?.hide()
            if error != nil {
                self.presentAlert("Error", message: "Posting user location failed", actionTitle: "Return")
            } else {
                if data != nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.presentAlert("Error", message: "Posting user location failed", actionTitle: "Return")
                }
            }
            
        }
    }
    
    //5. Post Data
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            dismissKeyboard()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        dismissKeyboard()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = nil
    }
}