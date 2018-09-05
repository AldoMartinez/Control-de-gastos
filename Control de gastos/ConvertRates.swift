//
//  ConvertRates.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 8/5/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit
import CoreData

class ConvertRates: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var moneyToConvert: UITextField!
    @IBOutlet var currencyCOP: UILabel!
    @IBOutlet var currencyMXN: UILabel!
    @IBOutlet var currencyUSD: UILabel!
    @IBOutlet var currencyEUR: UILabel!
    
    var money: Double! = 0.0
    var currencySelected: String! = "COP"
    var rates: [String:Double]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moneyToConvert.delegate = self
        
        //MARK: Obtengo los datos de la API
        let apiEndPoint = "http://data.fixer.io/api/latest?access_key=492a0e640aff2df1abd0a74dd61cad22&symbols=COP,USD,MXN,EUR"
        
        guard let url = URL(string: apiEndPoint) else{return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse{
                guard httpResponse.statusCode == 200 else {return}
                print("Fine")
            }
            guard let data = data else{ return }
            
            do{
                guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] else {return}
                guard let rates = dict["rates"] as? [String:Double] else { return }
                
                OperationQueue.main.addOperation {
                    self.rates = rates
                }
                
            }catch {
                print("Error")
            }
        }
        task.resume()
    }
    
    
    @IBAction func currencySelected(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if let moneda = sender.titleForSegment(at: index) {
            self.currencySelected = moneda
            if self.moneyToConvert.text != "" {
                if let moneyEntered = Double(self.moneyToConvert.text!) {
                    self.convertMoney(moneyEntered: moneyEntered)
                }else{
                    self.moneyToConvert.placeholder = "Ingresa un valor numerico"
                    self.moneyError()
                }
            }
        }
    }
    
    @IBAction func cleanFields(_ sender: Any?) {
        self.cleanAllFields()
    }
    
    //MARK: TextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if let moneyEntered = Double(textField.text!) {
            self.convertMoney(moneyEntered: moneyEntered)
        }else{
            self.moneyToConvert.placeholder = "Ingresa un valor numerico"
            self.moneyError()
        }
    }
    // Oculta el teclado al pulsar fuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func convertMoney(moneyEntered: Double) {
        self.money = moneyEntered
        self.currencyCOP.text = String(format: "%.2f", self.money * (rates!["COP"]!/rates![self.currencySelected]!)) + " COP"
        self.currencyMXN.text = String(format: "%.2f", self.money * (rates!["MXN"]!/rates![self.currencySelected]!)) + " MXN"
        self.currencyUSD.text = String(format: "%.2f", self.money * (rates!["USD"]!/rates![self.currencySelected]!)) + " USD"
        self.currencyEUR.text = String(format: "%.2f", self.money * (rates!["EUR"]!/rates![self.currencySelected]!)) + " EUR"
    }
    
    func moneyError() {
        let alert = UIAlertController(title: "Error", message: "Solo es posible ingresar valores numericos", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Entendido", style: .default) { (action) in
            self.cleanAllFields()
        }
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    func cleanAllFields() {
        self.moneyToConvert.text = ""
        self.moneyToConvert.placeholder = "Cantidad a convertir"
        self.currencyCOP.text = ""
        self.currencyMXN.text = ""
        self.currencyUSD.text = ""
        self.currencyEUR.text = ""
        self.money = 0.0
    }
    
}
