//
//  LineChart.swift
//  hack4no
//
//  Created by Laureen Schausberger on 28.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import Foundation
import Charts

class LineChart: BaseChart {
    
    let lineChartView               = LineChartView()
    var dataEntry: [ChartDataEntry] = []
    
    var delegate: GetChartData! {
        didSet {
            self.populateData()
            self.barChartSetup()
        }
    }
    
    func populateData() {
        self.nextHourTitles         = ["now", "+1h", "+2h", "+3h", "+4h"]
        self.nextHourProbabilities  = ["20", "25", "35", "15", "20"]
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
