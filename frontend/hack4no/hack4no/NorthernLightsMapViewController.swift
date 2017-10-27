//
//  NorthernLightsMapViewController.swift
//  hack4no
//
//  Created by Laureen Schausberger on 27.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import UIKit
import MapKit

class NorthernLightsMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lights: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.addOverlay()
        self.lights.image = #imageLiteral(resourceName: "test")
        self.lights.alpha = 0.2
        self.lights.isUserInteractionEnabled = false
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addOverlay() {
        let center = self.mapView.region.center
        let latitude = self.mapView.region.span.latitudeDelta / 2
        let longitude = self.mapView.region.span.longitudeDelta / 2
        
        let leftupPoint = CLLocationCoordinate2D(latitude: center.latitude + latitude, longitude: center.longitude - longitude)
        let rightdownPoint = CLLocationCoordinate2D(latitude: center.latitude - latitude, longitude: center.longitude + longitude)
        
        let anno = MKPointAnnotation()
        anno.coordinate = leftupPoint
        let anno2 = MKPointAnnotation()
        anno2.coordinate = rightdownPoint
        self.mapView.addAnnotations([anno, anno2])
        
        let circle = MKCircle(center: CLLocationCoordinate2D(latitude: 70.067581, longitude: 19.249916), radius: 1000)
        self.mapView.add(circle)
    }
    
    
     
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlay = MKCircleRenderer(overlay: overlay)
        overlay.strokeColor = UIColor.magenta.withAlphaComponent(0)
        overlay.fillColor   = UIColor.magenta
        overlay.alpha = 0.2
        return overlay
    }
    
    // mapView(:viewForAnnotation:) is the method that gets called for every annotation you add to the map (kind of like tableView(:cellForRowAtIndexPath:) when working with table views), to return the view for each annotation.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var view: MKAnnotationView
        view = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        view.image = #imageLiteral(resourceName: "test")
            return view
    }
 

}
