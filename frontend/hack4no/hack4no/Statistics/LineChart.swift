//
//  LineChart.swift
//  hack4no
//
//  Created by Laureen Schausberger on 28.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import Foundation
import Charts

class LineChart: UIView {
    let lineChartView = LineChartView()
    var dataEntry: [ChartDataEntry] = []
    
    //Chart data
    var nextHourTitles = [String]()
    var nextHourProbabilities = [String]()
    
    var delegate: GetChartData! {
        didSet {
            self.populateData()
            self.barChartSetup()
        }
    }
    
    func populateData() {
        self.nextHourTitles  = ["now", "+1h", "+2h", "+3h", "+4h"]
        self.nextHourProbabilities    = ["20", "25", "35", "15", "20"]
    }
    
    func barChartSetup() {
        //Bar chart config
        self.backgroundColor = UIColor.white
        self.addSubview(lineChartView)
        self.lineChartView.translatesAutoresizingMaskIntoConstraints                        = false
        self.lineChartView.topAnchor.constraint(equalTo: self.topAnchor).isActive           = true
        self.lineChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive     = true
        self.lineChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive   = true
        self.lineChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        //animation
        self.lineChartView.animate(xAxisDuration: 2, yAxisDuration: 2)
        
        //population
        self.setBarChart(dataPoints: nextHourTitles, values: nextHourProbabilities)
    }
    
    func setBarChart(dataPoints: [String], values: [String]) {
        self.lineChartView.noDataTextColor = UIColor.white
        self.lineChartView.noDataText = "No data for the chart."
        self.lineChartView.backgroundColor       = UIColor.clear
        self.lineChartView.gridBackgroundColor   = UIColor.white
        
        for i in 0..<dataPoints.count {
            let dataPoint = ChartDataEntry(x: Double(i), y: Double(values[i])!)
            self.dataEntry.append(dataPoint)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntry, label: "%")
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
        chartDataSet.colors = [UIColor.cyan]
        chartDataSet.setCircleColor(UIColor.cyan)
        chartDataSet.circleRadius = 4

        //gradient fill
        let gradiantColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0] //gradient position
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradiantColors, locations: colorLocations) else {
            print("gradient error!")
            return
        }
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90)
        chartDataSet.drawFilledEnabled = true
        
        let formatter: ChartFormatter = ChartFormatter()
        formatter.setValues(values: dataPoints)
        let xaxis: XAxis = XAxis()
        xaxis.valueFormatter = formatter
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.xAxis.drawGridLinesEnabled = false
        self.lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        self.lineChartView.legend.enabled = false
        self.lineChartView.chartDescription?.enabled = false
        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.leftAxis.drawGridLinesEnabled = false
        self.lineChartView.leftAxis.drawLabelsEnabled = true
        self.lineChartView.xAxis.granularityEnabled = true
        self.lineChartView.xAxis.granularity = 1.0
        self.lineChartView.data = chartData
    }
}
