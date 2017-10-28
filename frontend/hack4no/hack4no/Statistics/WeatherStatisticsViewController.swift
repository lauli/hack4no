//
//  WeatherStatisticsViewController.swift
//  hack4no
//
//  Created by Laureen Schausberger on 28.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class WeatherStatisticsViewController: UIViewController, GetChartData {
    
    //Chart data
    var nextHourTitles = [String]()
    var nextHourProbabilities = [String]()
    
    var cityCoordinates: [CLLocationCoordinate2D] = []
    
    @IBOutlet weak var barChartView: UIView!
    @IBOutlet weak var lineChartView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateChartData()
        //self.populateCityData()
        self.lineChart()
    }
    
    func populateCityData() {
        //coordinates for cities
        let trondheimCoordinates = CLLocationCoordinate2D (latitude: 63.4305149, longitude: 10.3950528)
        let gjovikCoordinates = CLLocationCoordinate2D (latitude: 60.7954302, longitude: 10.6916303)
        let tromsoCoordinates = CLLocationCoordinate2D (latitude: 60.1529576, longitude: 10.2620129)
        let bergenCoordinates = CLLocationCoordinate2D (latitude: 60.39126279999999, longitude: 5.3220544)
        let alesundCoordinates = CLLocationCoordinate2D (latitude: 62.47222840000001, longitude: 6.1494821)
        let osloCoordinates = CLLocationCoordinate2D (latitude: 59.9138688, longitude: 10.7522454)
        let stavangerCoordinates = CLLocationCoordinate2D (latitude: 58.9699756, longitude: 5.73310739)
        let kristiansandCoordinates = CLLocationCoordinate2D (latitude: 58.159911899, longitude: 8.0182064)
        cityCoordinates = [trondheimCoordinates, gjovikCoordinates, tromsoCoordinates, bergenCoordinates, alesundCoordinates, osloCoordinates, stavangerCoordinates, kristiansandCoordinates]
    }
    
    func populateChartData() {
        self.nextHourTitles = ["00:00", "02:00", "04:00", "06:00", "08:00", "10:00", "12:00", "14:00"]
        self.nextHourProbabilities = ["-2", "0", "1", "5", "8", "9", "11", "12"]
        self.getChartData(with: nextHourTitles, values: nextHourProbabilities)
    }
    
    func lineChart() {
        let lineChart = SmoothLineChart (frame: CGRect(x: 0, y: 0, width: self.view.frame.width-20, height:  200))
        lineChart.delegate = self
        lineChart.backgroundColor = UIColor.clear
        self.lineChartView.addSubview(lineChart)
    }
    
    func getChartData(with dataPoints: [String], values: [String]) {
        self.nextHourTitles = dataPoints
        self.nextHourProbabilities = values
    }
    
}
