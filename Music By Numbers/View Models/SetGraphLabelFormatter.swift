//
//  SetGraphLabelFormatter.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/23/22.
//

import Foundation
import Charts

class SetGraphLabelFormatter: IndexAxisValueFormatter {
    
//    let titles = ["0","1","2","3","4","5","6","7","8","9","10","11"]
    
    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let labels = ["0","1","2","3","4","5","6","7","8","9","10","11"]
        return labels[Int(value)]
    }
}
