//
//  AddGeoLocViewController.swift
//  SDKPlayground
//
//  Created by Prateek Jain on 6/30/18.
//  Copyright © 2018 Prateek Jain. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class AddGeoLocViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var radius: UITextView!
    @IBOutlet weak var message_exit: UITextView!
    @IBOutlet weak var message_entry: UITextView!
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    let regionRadius: CLLocationDistance = 700
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
    addButton.isEnabled = false
    mapview.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showSearchBar(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func addGeoLoc(_ sender: Any) {
        let coordinate = mapview.centerCoordinate
        let radius = Double(self.radius.text!) ?? 0
        let identifier = NSUUID().uuidString
        let note_entry = message_entry.text
        let note_exit = message_exit.text
       
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapview.annotations.count != 0{
            annotation = self.mapview.annotations[0]
            self.mapview.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
        //3
        self.pointAnnotation = MKPointAnnotation()
        self.pointAnnotation.title = searchBar.text
        self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
        
        
        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
        self.mapview.centerCoordinate = self.pointAnnotation.coordinate
        //self.mapview.addAnnotation(self.pinAnnotationView.annotation!)
        let initialLocation = CLLocation(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
        self.centerMapOnLocation(location: initialLocation)
        //self.mapview.setCenter(initialLocation.coordinate, animated: true)
            
        }
    }
    
    // Function to set center on map view
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        self.mapview.setRegion(coordinateRegion, animated: true)
        
        let alert = UIAlertController(title: "Next step", message: "Drag and Zoom the map such that the centre of region is pin.", preferredStyle:UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: "OK", style:
            UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void
                in self.dismiss(animated: true, completion: nil)
                
        }))
        
        self.present(alert,animated: true, completion: nil)
    }
    

}
