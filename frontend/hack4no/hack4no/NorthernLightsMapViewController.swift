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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.addOverlay()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addOverlay() {
        /*
        let coords1 = CLLocationCoordinate2D(latitude: 70.067581,                   longitude: 19.249916)
        let coords2 = CLLocationCoordinate2D(latitude: coords1.latitude,            longitude: coords1.longitude+0.004)
        let coords3 = CLLocationCoordinate2D(latitude: coords1.latitude+0.004,   longitude: coords1.longitude+0.004)
        let coords4 = CLLocationCoordinate2D(latitude: coords1.latitude+0.004,   longitude: coords1.longitude)
        let testcoords:[CLLocationCoordinate2D] = [coords1, coords2, coords3, coords4]
        */
        //let poly = MKPolygon(coordinates: testcoords, count: testcoords.count)
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
 
    /*
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let poly = overlay as? MKMapPoint else {return MKOverlayRenderer()}
        
        let circleRenderer = MKMapPoint
        circleRenderer.colo
        circleRenderer.strokeColor = UIColor.green
        circleRenderer.fillColor = UIColor.green
        circleRenderer.alpha = 0.2
        return circleRenderer
    }
 */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
