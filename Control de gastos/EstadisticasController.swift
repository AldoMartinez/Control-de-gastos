//
//  EstadisticasController.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 9/7/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit
import Charts

class EstadisticasController: UIViewController {

    @IBOutlet var lineChart: LineChartView!
    
    
    var numbers: [Double] = [15.0,13.2,12.3,11.9,10.2,5.5,2.3,1.8,7.1,10.0]
    var numbers2: [Double] = [10.0,20.0,18.0,11.0,2.0,1.0,20.0,13.0,17.0,2.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGraph()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateGraph() {
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<numbers.count {
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            lineChartEntry.append(value)
        }
        
        let xAxis = lineChart.xAxis
        xAxis.labelPosition = .bottom
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Prueba")
        line1.colors = [NSUIColor.blue]
        
        let data = LineChartData()
        data.addDataSet(line1)
        self.lineChart.data = data
        self.lineChart.chartDescription?.text = "My first chart"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
