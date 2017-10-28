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
    
    @IBOutlet weak var barChartView: UIView!
    @IBOutlet weak var lineChartView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateChartData()
        self.barChart()
        self.lineChart()
    }
    
    func populateChartData() {
        self.nextHourTitles = ["now","15 min", "30 min", "45 min"]
        self.nextHourProbabilities = ["20", "25", "25", "30"]
        self.getChartData(with: nextHourTitles, values: nextHourProbabilities)
    }
    
    func barChart() {
        let barChart = BarChart (frame: CGRect(x: 0, y: 8, width: self.view.frame.width-20, height:  180))
        barChart.delegate = self
        barChart.backgroundColor = UIColor.clear
        self.barChartView.addSubview(barChart)
    }
    
    func lineChart() {
        let lineChart = LineChart (frame: CGRect(x: 0, y: 0, width: self.view.frame.width-20, height:  200))
        lineChart.delegate = self
        lineChart.backgroundColor = UIColor.clear
        self.lineChartView.addSubview(lineChart)
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
