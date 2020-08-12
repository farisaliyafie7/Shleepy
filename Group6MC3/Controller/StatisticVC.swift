//
//  StatisticVC.swift
//  Group6MC3
//
//  Created by Faris Ali Yafie on 24/07/20.
//  Copyright © 2020 Faris Ali Yafie. All rights reserved.
//

import UIKit
import Charts

class StatisticVC: UIViewController, ChartViewDelegate {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var pieView: PieChartView!
    //var barChart = BarChartView()
    
    let summaryDefaults = UserDefaults.standard
    var sumArray: [Bool] = [true, true, false]
    var countS = 0.0
    var countF = 0.0
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //barChart.delegate = self
        if let sum = summaryDefaults.array(forKey: "summaryArray") as? [Bool]{
            sumArray = sum
        }
        counterChart()
        setupPieChart()
    }
    
    func counterChart(){
        for i in 0..<sumArray.count{
            if sumArray[i] == true{
                countS += 1
            }else{
                countF += 1
            }
        }
        let percent = Int(countS*100)/sumArray.count
        countLabel.text = "Success Count : \(Int(countS))"
        rateLabel.text = "Success rate : \(percent)%"
    }
    
    func setupPieChart(){
        pieView.chartDescription?.enabled = false
        pieView.drawHoleEnabled = false
        pieView.rotationAngle = 0
        pieView.rotationEnabled = false
        pieView.isUserInteractionEnabled = false
        pieView.legend.enabled = false
        
        var entries: [PieChartDataEntry] = Array()
        entries.append(PieChartDataEntry(value: countS, label: "On time"))
        entries.append(PieChartDataEntry(value: countF, label: "Oversleep"))
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        let c1 = NSUIColor(hex: 0xFFA500)
        let c2 = NSUIColor(hex: 0x4F0147)
        
        dataSet.colors = [c1, c2]
        dataSet.drawValuesEnabled = false
        
        pieView.data = PieChartData(dataSet: dataSet)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
//        barChart.center = view.center
//        view.addSubview(barChart)
//
//        var entry = [BarChartDataEntry]()
//        for x in 0..<10{
//            entry.append(BarChartDataEntry(x: Double(x), y: Double(x)))
//        }
//
//        let set = BarChartDataSet(entries: entry)
//        set.colors = ChartColorTemplates.joyful()
//        let data = BarChartData(dataSet: set)
//
//        barChart.data = data
//
//    }

}

extension NSUIColor{
    convenience init(red: Int,green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int){
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}
