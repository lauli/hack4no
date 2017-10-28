//
//  BarChart.swift
//  hack4no
//
//  Created by Laureen Schausberger on 27.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import Foundation
import Charts
import UIKit

class BarChart: BaseChart {
    
    let barChartView                    = HorizontalBarChartView()
    var dataEntry: [BarChartDataEntry]  = []
    
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
        self.addSubview(self.barChartView)
        self.setup(chartview: self.barChartView)
        self.barChartView.animate(xAxisDuration: 2, yAxisDuration: 2)
        self.setBarChart(dataPoints: nextHourTitles, values: nextHourProbabilities)
    }
    
    func setBarChart(dataPoints: [String], values: [String]) {
        
        for i in 0..<dataPoints.count {
            let dataPoint = BarChartDataEntry(x: Double(i), y: Double(values[i])!)
            self.dataEntry.append(dataPoint)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "%")
        chartDataSet.colors = [UIColor.white]

        let chartData    = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
        
        self.setupFormatterAndXaxis(for: self.barChartView, dataPoints: dataPoints)
        
        self.barChartView.data = chartData
    }
}













