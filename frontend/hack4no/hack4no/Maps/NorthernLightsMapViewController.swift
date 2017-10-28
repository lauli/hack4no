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

class NorthernLightsMapViewController: BaseMapController {

    
    override func viewDidLoad() {
        self.initialLocation = CLLocation (latitude: 56.723479, longitude: -111.380193)
        self.regionRadius       = 200000
        self.centerMapOnLocation(location: initialLocation)
        
        self.addOverlay()
        self.mapView.delegate = self
        self.lights.image     = nil
        self.lights.alpha     = 0.5
        self.lights.isUserInteractionEnabled = false
        
        let mapDragRecognizer      = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(gestureRecognizer:)))
        mapDragRecognizer.delegate = self
        self.mapView.addGestureRecognizer(mapDragRecognizer)
        self.getImageFromRestService()
    }
    
    override func getImageFromRestService () {
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
    
    override func getImageFromHost (fromURL urlImage: URL) {
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

}
