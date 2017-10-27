//
//  MagnetfieldStatsticsViewController.swift
//  hack4no
//
//  Created by Laureen Schausberger on 27.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import Foundation
import Charts

protocol GetChartData {
    func getChartData (with dataPoints: [String], values: [String])
    var nextHourTitles: [String] {get set}
    var nextHourProbabilities: [String] {get set}
}


class MagnetfieldStatsticsViewController: UIViewController, GetChartData {
    
    //Chart data
    var nextHourTitles = [String]()
    var nextHourProbabilities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateChartData()
        self.barChart()
    }
    
    func populateChartData() {
        self.nextHourTitles = ["now","15 min", "30 min", "45 min"]
        self.nextHourProbabilities = ["20", "25", "25", "30"]
        self.getChartData(with: nextHourTitles, values: nextHourProbabilities)
    }
    
    func barChart() {
        let barChart = BarChart (frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height:  300))
        barChart.delegate = self
        self.view.addSubview(barChart)
    }
    
    func getChartData(with dataPoints: [String], values: [String]) {
        self.nextHourTitles = dataPoints
        self.nextHourProbabilities = values
    }
    
    
    
}

public class ChartFormatter: NSObject, IAxisValueFormatter {
    
    var nextHourProbabilities = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return nextHourProbabilities[Int(value)]
    }
    
    public func setValues (values: [String]) {
        self.nextHourProbabilities = values
    }
}
