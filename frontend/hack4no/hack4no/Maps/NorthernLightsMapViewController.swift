//
//  NorthernLightsMapViewController.swift
//  hack4no
//
//  Created by Laureen Schausberger on 27.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class NorthernLightsMapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lights: UIImageView!
    
    var leftupPoint: CLLocationCoordinate2D?
    var rightdownPoint: CLLocationCoordinate2D?

    // set initial location in Oslo
    let initialLocation = CLLocation (latitude: 60.1529576, longitude: 10.2620129)
    let regionRadius: CLLocationDistance = 20000

    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location: initialLocation)
        self.addOverlay()
        self.mapView.delegate = self
        self.lights.image     = nil
        self.lights.alpha     = 0.2
        self.lights.isUserInteractionEnabled = false
        
        let mapDragRecognizer      = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(gestureRecognizer:)))
        mapDragRecognizer.delegate = self
        self.mapView.addGestureRecognizer(mapDragRecognizer)
        self.getImageFromRestService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            print("Map drag ended, make call to REST-Server")
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  self.regionRadius, self.regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func getImageFromRestService () {
        //build request string
        let serverIP = "192.168.43.145"
        let leftUpString = "UL/" + String(describing: self.leftupPoint!.latitude) + "/" + String(describing: self.leftupPoint!.longitude) + "/"
        let rightDownString = "LR/" + String(describing: self.rightdownPoint!.latitude) + "/" + String(describing: self.rightdownPoint!.longitude) + "/"
        let requestString = ("http://" + serverIP + ":5537/overlay/" + leftUpString + rightDownString + "ratio/3" )
        print(requestString)

        Alamofire.request(requestString).responseString { response in
            print("String:\(String(describing: response.result.value))")
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(data)
                    if let urlImage = URL(string: "http://" + serverIP + ":5537/" + data) {
                        self.getImageFromHost(fromURL: urlImage)
                    }
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
        
        
    }
    
    func getImageFromHost (fromURL urlImage: URL) {
        let session = URLSession(configuration: .default)
        
        //creating a dataTask
        let getImageFromUrl = session.dataTask(with: urlImage) { (data, response, error) in

            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            //displaying the image
                            DispatchQueue.main.async() {
                                self.setImage(image)
                            }
                        }
                    } else {
                        print("Image file is corrupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        
        //starting the download task
        getImageFromUrl.resume()
    }
    
    func setImage (_ image: UIImage) {
        self.lights.image = image
    }
    
    func addOverlay() {
        let center = self.mapView.region.center
        let latitude = self.mapView.region.span.latitudeDelta / 2
        let longitude = self.mapView.region.span.longitudeDelta / 2
        
        self.leftupPoint = CLLocationCoordinate2D(latitude: center.latitude + latitude, longitude: center.longitude - longitude)
        self.rightdownPoint = CLLocationCoordinate2D(latitude: center.latitude - latitude, longitude: center.longitude + longitude)
        
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
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView
        view = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        view.image = #imageLiteral(resourceName: "test")
            return view
    }
 

}
