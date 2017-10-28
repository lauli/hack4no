//
//  LineChart.swift
//  hack4no
//
//  Created by Laureen Schausberger on 28.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import Foundation
import Charts

class SmoothLineChart: BaseChart {
    
    let lineChartView               = LineChartView()
    var dataEntry: [ChartDataEntry] = []
    
    var delegate: GetChartData! {
        didSet {
            self.populateData()
            self.barChartSetup()
        }
    }
    
    func populateData() {
        self.nextHourTitles         = ["00:00", "02:00", "04:00", "06:00", "08:00", "10:00", "12:00", "14:00"]
        self.nextHourProbabilities  = ["-2", "0", "1", "5", "8", "9", "11", "12"]
    }
    
    func barChartSetup() {
        self.addSubview(self.lineChartView)
        self.setLineChart(dataPoints: nextHourTitles, values: nextHourProbabilities)
        self.setup(chartview: self.lineChartView)
        self.lineChartView.animate(xAxisDuration: 2, yAxisDuration: 2)
    }
    
    func setLineChart(dataPoints: [String], values: [String]) {
        
        for i in 0..<dataPoints.count {
            let dataPoint = ChartDataEntry(x: Double(i), y: Double(values[i])!)
            self.dataEntry.append(dataPoint)
        }
        
        let chartDataSet            = LineChartDataSet(values: dataEntry, label: "%")
        chartDataSet.colors         = [UIColor.white]
        chartDataSet.circleRadius   = 4
        chartDataSet.setCircleColor(UIColor.white)
        chartDataSet.cubicIntensity = 0.2
        chartDataSet.mode           = .cubicBezier
        
        let chartData               = LineChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
        
        //gradient fill
        let gradiantColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0] //gradient position
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradiantColors, locations: colorLocations) else {
            print("gradient error!")
            return
        }
        chartDataSet.fill               = Fill.fillWithLinearGradient(gradient, angle: 90)
        chartDataSet.drawFilledEnabled  = true
        
        self.setupFormatterAndXaxis(for: self.lineChartView, dataPoints: dataPoints)
        
        self.lineChartView.data = chartData
    }
}

