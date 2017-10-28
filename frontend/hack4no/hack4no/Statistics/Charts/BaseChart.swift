//
//  BaseChart.swift
//  hack4no
//
//  Created by Laureen Schausberger on 28.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import Foundation
import Charts
import UIKit

class BaseChart: UIView {
    
    //Chart data
    var nextHourTitles = [String]()
    var nextHourProbabilities = [String]()
    
    func setup(chartview: ChartViewBase) {
        
        chartview.translatesAutoresizingMaskIntoConstraints                        = false
        chartview.topAnchor.constraint(equalTo: self.topAnchor).isActive           = true
        chartview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive     = true
        chartview.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive   = true
        chartview.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        chartview.noDataTextColor       = UIColor.white
        chartview.noDataText            = "No data for the chart."
        chartview.backgroundColor       = UIColor.clear
        
        chartview.xAxis.granularityEnabled      = true
        chartview.xAxis.granularity             = 1.0
        
        chartview.legend.enabled                = true
        chartview.chartDescription?.enabled     = false
    }
    
    func setupFormatterAndXaxis(for chartview: ChartViewBase, dataPoints: [String]) {
        let formatter: ChartFormatter = ChartFormatter()
        formatter.setValues(values: dataPoints)
        
        let xaxis: XAxis        = XAxis()
        xaxis.valueFormatter    = formatter
        chartview.xAxis.labelPosition           = .bottom
        chartview.xAxis.drawGridLinesEnabled    = false
        chartview.xAxis.valueFormatter          = xaxis.valueFormatter
        /*
        chartview.rightAxis.enabled             = false
        chartview.leftAxis.drawGridLinesEnabled = true
        chartview.leftAxis.drawLabelsEnabled    = true
 */
    }
    
    
}
