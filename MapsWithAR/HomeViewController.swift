//
//  HomeViewController.swift
//  MapsWithAR
//
//  Created by Tushar Vengurlekar on 06/01/18.
//  Copyright © 2018 Tushar's. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    struct LocalConstant {
        
        // SEGUE
        static let segueToARView = "SEGUE_HOME_AR"
        
        // String Constants
        static let stringCurrentLOcation = "Current location"
        static let stringARView = "ARView"
        
        static let currentLocation = 0
        static let melbourne = 1
        static let mumbai = 2
        static let london = 3

    }
    
    var locationManager:CLLocationManager!
    var mapView:MKMapView!
    var selectedLocation:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        determineCurrentLocation()
    }
    
    func createMapView() {
        mapView = MKMapView()
        
        mapView.frame = CGRect(x: self.view.frame.origin.x,
                               y: self.view.frame.origin.y,
                               width: self.view.frame.size.width,
                               height: self.view.frame.size.height)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showAnnotations(mapView.annotations, animated: true)
        mapView.delegate = self
        mapView.center = view.center
        
        view.addSubview(mapView)
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
                
        addAnnotation(id: LocalConstant.currentLocation, userLocation: userLocation)
        addAnnotation(id: LocalConstant.melbourne, userLocation: CLLocation(latitude: -37.814, longitude: 144.96332))
        addAnnotation(id: LocalConstant.mumbai, userLocation: CLLocation(latitude: 18.910000, longitude: 72.809998))
        addAnnotation(id: LocalConstant.london, userLocation: CLLocation(latitude: 51.509865, longitude: -0.118092))
    
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if(annotation.isKind(of: MKUserLocation().classForCoder)) {
            return nil
        }
        
        let annotationView:MKAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "loc")
        annotationView.canShowCallout = true
        annotationView.tag = (annotation as! CustomPointAnnotation).tag
        annotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        
        return annotationView;
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        selectedLocation = view.tag
        if(view.tag != LocalConstant.currentLocation) {
            self.performSegue(withIdentifier: LocalConstant.segueToARView, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let arview:ARViewController = segue.destination as! ARViewController
        print(selectedLocation)
        arview.selectedAR =  Double(exactly: selectedLocation)
    }
    
    func addAnnotation(id:Int, userLocation:CLLocation ) {
        let myAnnotation: CustomPointAnnotation = CustomPointAnnotation()
        
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);

        if(id == LocalConstant.currentLocation) {
            myAnnotation.title = LocalConstant.stringCurrentLOcation
        }
        else {
            myAnnotation.title = LocalConstant.stringARView
        }
        
        myAnnotation.tag = id
        mapView.addAnnotation(myAnnotation)
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    var tag: Int!
}

