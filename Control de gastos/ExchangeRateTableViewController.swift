//
//  ExchangeRateTableViewController.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 7/30/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit

class ExchangeRateTableViewController: UITableViewController {

    var exchangeRates = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Obtengo los datos de la API
        let apiEndPoint = "http://data.fixer.io/api/latest?access_key=492a0e640aff2df1abd0a74dd61cad22&symbols=COP,USD,MXN"
        
        guard let url = URL(string: apiEndPoint) else{return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse{
                guard httpResponse.statusCode == 200 else {return}
                print("Fine")
            }
            guard let data = data else{ return }
            
            do{
                guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] else {return}
                guard let rates = dict["rates"] as? [String:Double], let base = dict["base"] as? String, let date = dict["date"] as? String else { return }
                
                let currencies = rates.keys.sorted()
                
                for currency in currencies {
                    if let rate = rates[currency]{
                        self.exchangeRates.append("1 \(base) = \(rate) \(currency)")
                    }
                }
                OperationQueue.main.addOperation {
                    self.navigationController?.navigationBar.topItem?.title = "Update on \(date)"
                    self.tableView.reloadData()
                }
            }catch {
                print("Error")
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exchangeRates.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = exchangeRates[indexPath.row]
        return cell
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
