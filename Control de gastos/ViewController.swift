//
//  ViewController.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 7/30/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var viewWithBlurEffect: UIVisualEffectView!
    @IBOutlet var AddSell: UIView!
    
    var currency: String = "COP"
    var currentRate: Double = 0
    var rates: [String:Double]? = nil
    var moneySpent : Double = 0.0
    
    var fecha: String!
    var formatter = DateFormatter()
    var effect: UIVisualEffect!
    
    @IBOutlet var monedaSelected: UILabel!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var gasto: UITextField!
    @IBOutlet var precio: UITextField!
    
    @IBAction func currencySelected(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        if let moneda = segmentedControl.titleForSegment(at: index) {
            self.currency = moneda
            switch moneda {
            case "USD":
                currentRate = self.rates!["MXN"]!/self.rates!["USD"]!
                break
            case "COP":
                currentRate = self.rates!["MXN"]!/self.rates!["COP"]!
                break
            case "MXN":
                currentRate = 1
                break
            default:
                break
            }
        }
    }
    @IBAction func saveSale(_ sender: UIButton) {
        let precioPesosMxn = Double(self.precio.text!)! * self.currentRate
        
        let compra = Compra(context: PersistenceService.context)
        compra.nombre = self.gasto.text!
        compra.precio = precioPesosMxn
        compra.fecha = self.fecha
        compra.precioOriginal = Double(self.precio.text!)!
        compra.moneda = self.currency
        PersistenceService.saveContext()
        print(compra.fecha!)
        self.gasto.text = ""
        self.precio.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if firstRun {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstLaunchController")
            self.present(controller, animated: true, completion: nil)
        }
        
        effect = viewWithBlurEffect!.effect
        viewWithBlurEffect.effect = nil
        
        AddSell.layer.cornerRadius = 5
        

        formatter.dateStyle = .medium
        self.fecha = formatter.string(from: Date())
        // Do any additional setup after loading the view, typically from a nib.
        self.gasto.delegate = self
        self.precio.delegate = self
        
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
                guard let rates = dict["rates"] as? [String:Double] else { return }
                
                OperationQueue.main.addOperation {
                    self.rates = rates
                    self.currentRate = rates["MXN"]!/rates["COP"]!

                    do{
                        try PersistenceService.context.save()
                    }catch{
                        print("Error al guardar exchange rate")
                    }
                }
                
            }catch {
                print("Error")
            }
        }
        task.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animanteIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Funciones
    func animanteIn() {
        self.view.addSubview(AddSell)
        AddSell.center = self.view.center
        AddSell.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        AddSell.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.viewWithBlurEffect.effect = self.effect
            self.AddSell.alpha = 1
            self.AddSell.transform = CGAffineTransform.identity
        }
    }

    //MARK: TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // Funcion que desaparece el teclado cuando pulsas afuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}

