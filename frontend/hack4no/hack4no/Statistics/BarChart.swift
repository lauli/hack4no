//
//  BarChart.swift
//  hack4no
//
//  Created by Laureen Schausberger on 27.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import Foundation
import Charts

class BarChart: UIView {
    let barChartView = HorizontalBarChartView()
    var dataEntry: [BarChartDataEntry] = []
    
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
        self.nextHourProbabilities  = self.delegate.nextHourProbabilities
        self.nextHourTitles         = self.delegate.nextHourTitles
    }
    
    func barChartSetup() {
        //Bar chart config
        self.backgroundColor = UIColor.white
        self.addSubview(barChartView)
        self.barChartView.translatesAutoresizingMaskIntoConstraints = false
        self.barChartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.barChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.barChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.barChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        //animation
        self.barChartView.animate(xAxisDuration: 2, yAxisDuration: 2)
        
        //population
        self.setBarChart(dataPoints: nextHourTitles, values: nextHourProbabilities)
    }
    
    func setBarChart(dataPoints: [String], values: [String]) {
        self.barChartView.noDataTextColor = UIColor.white
        self.barChartView.noDataText = "No data for the chart."
        self.barChartView.backgroundColor = UIColor.white
        
        for i in 0..<dataPoints.count {
            let dataPoint = BarChartDataEntry(x: Double(i), y: Double(values[i])!)
            self.dataEntry.append(dataPoint)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "%")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
        chartDataSet.colors = [UIColor.cyan]
        
        let formatter: ChartFormatter = ChartFormatter()
        formatter.setValues(values: dataPoints)
        let xaxis: XAxis = XAxis()
        xaxis.valueFormatter = formatter
        self.barChartView.xAxis.labelPosition = .bottom
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        self.barChartView.legend.enabled = true
        self.barChartView.chartDescription?.enabled = false
        self.barChartView.rightAxis.enabled = false
        self.barChartView.leftAxis.drawGridLinesEnabled = false
        self.barChartView.leftAxis.drawLabelsEnabled = true
        self.barChartView.xAxis.granularityEnabled = true
        self.barChartView.xAxis.granularity = 1.0
        self.barChartView.data = chartData
    }
}
