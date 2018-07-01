//
//  ViewController.swift
//  SDKPlayground
//
//  Created by Prateek Jain on 6/29/18.
//  Copyright © 2018 Prateek Jain. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var status_location: UITextView!
    let regionRadius: CLLocationDistance = 500
    var locationManager : CLLocationManager = CLLocationManager()
    var longitude : CLLocationDegrees!
    var latitude : CLLocationDegrees!
    let annotation = MKPointAnnotation()
    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapview.delegate = self
        status_location.text="Wait Getting Current Location.."
        
        //Initialise coreLocation Manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Function if location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
    
            // set current location as initial location
            longitude=long
            latitude=lat
            print ("\(lat)++++++++\(long)")
            status_location.text="Current Location"
            let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapview.addAnnotation(annotation)
            centerMapOnLocation(location: initialLocation)
            
            
        } else {
            print("No coordinates")
        }
    }
    
    
    // Function if fails to retrieve location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // Function to set center on map view
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapview.setRegion(coordinateRegion, animated: true)
    }
}
