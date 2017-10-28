//
//  RouteMapViewController.swift
//  hack4no
//
//  Created by Laureen Schausberger on 27.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import UIKit
import MapKit

class RouteMapViewController: BaseViewController, MKMapViewDelegate {
    // tromso   69.653333, 18.958087
    // hill     70.067581, 19.249916
    let sourceLocation      = CLLocationCoordinate2D(latitude: 69.653333, longitude: 18.958087)
    let destinationLocation = CLLocationCoordinate2D(latitude: 70.067581, longitude: 19.249916)
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.renderRoute()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func renderRoute() {
        // TROMSO
        let sourcePlacemark     = MKPlacemark(coordinate: self.sourceLocation, addressDictionary: nil)
        let sourceMapItem       = MKMapItem(placemark: sourcePlacemark)
        let sourceAnnotation    = MKPointAnnotation()
        sourceAnnotation.title  = "You are here"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        // HILL
        let destinationPlacemark    = MKPlacemark(coordinate: self.destinationLocation, addressDictionary: nil)
        let destinationMapItem      = MKMapItem(placemark: destinationPlacemark)
        let destinationAnnotation   = MKPointAnnotation()
        destinationAnnotation.title = "Recommendation"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest            = MKDirectionsRequest()
        directionRequest.source         = sourceMapItem
        directionRequest.destination    = destinationMapItem
        directionRequest.transportType  = .walking
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 2.0
        
        return renderer
    }
}
