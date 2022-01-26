//
//  SetViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/23/22.
//

import UIKit
import Charts

class SetViewController: UIViewController {

    var normalForm: [Int]?
    var primeForm: [Int]?
    
//    @IBOutlet var setGraphView: RadarChartView!
    
    @IBOutlet var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(primeForm)
//        buildGraph(pitchSet: primeForm ?? [] )
        // Do any additional setup after loading the view.
    }
    
//    func buildGraph(pitchSet: [Int?]) {
//        let pcList = [0,1,2,3,4,5,6,7,8,9,10,11]
//        var pcCount = [Int]()
//        for i in pcList {
//            if pitchSet.contains(i) {
//                pcCount.append(1)
//            } else {
//                pcCount.append(0)
//            }
//        }
//        
//        var dataEntries = [RadarChartDataEntry]()
//        for i in pcCount {
//            dataEntries.append(RadarChartDataEntry(value: Double(i)))
//        }
//        
//        var dataSet = RadarChartDataSet(entries: dataEntries)
//        
//        var graphData = RadarChartData(dataSet: dataSet)
////        setGraphView.yAxis.valueFormatter = SetGraphLabelFormatter()
////        setGraphView.xAxis.axisMaximum = 1.0
//        
////        setGraphView.data = graphData
////        let greenDataSet = RadarChartDataSet(
////            entries: [
////                RadarChartDataEntry(value: 210),
//        
////        var dataEntries = [RadarChartDataEntry]()
//////        var entries = [Int]()
////        for i in 0..<pcList.count {
////            dataEntries.append(RadarChartDataEntry(value: Double(pcCount[i])))
////        }
////        let entries = RadarChartDataSet(entries: dataEntries)
////        let data = RadarChartData(dataSets: entries)
//
//        // 3
//        
////        print(pcCount)
////        setGraphView.data = data
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
