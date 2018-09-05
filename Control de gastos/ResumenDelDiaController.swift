//
//  ResumenDelDiaController.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 8/5/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import CoreData
import UIKit

class ResumenDelDiaController: UITableViewController{
    @IBOutlet var table: UITableView!
    var compras = [Compra]()
    var fecha: String!
    let formatter = DateFormatter()
    var currentRate: Double = 0
    var rates: [String:Double]? = nil
    
    @IBOutlet var ViewCOP: UIView!
    @IBOutlet var precioEnCOP: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle = .medium
        self.fecha = formatter.string(from: Date())
        // Le doy borde redondo a la vista
        self.ViewCOP.layer.cornerRadius = 10
        //Preparo el long press recognizer
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(press:)))
        longPressRecognizer.minimumPressDuration = 1.0
        self.table.addGestureRecognizer(longPressRecognizer)
    }
    override func viewWillAppear(_ animated: Bool) {
        // Se hace la peticion para recuperar los datos guardados
        let fetchRequest: NSFetchRequest<Compra> = Compra.fetchRequest()
        let change = NSFetchRequest<NSFetchRequestResult>(entityName: "ExchangeRate")
        do{
            self.compras = []
            let compras = try PersistenceService.context.fetch(fetchRequest)
            for compra in compras {
                if compra.fecha == self.fecha {
                    self.compras.append(compra)
                }
            }
            let result = try PersistenceService.context.fetch(change)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "Change")!)
                self.currentRate = data.value(forKey: "Change") as! Double
            }
        }catch{}
        self.table?.reloadData()
        
    }
    
    //MARK: Funciones UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.compras.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda") as! ResumenDiarioCell
        
        cell.compra.text = compras[indexPath.row].nombre
        cell.precio.text = "$" + String(format:"%.2f", compras[indexPath.row].precio)
        return cell
    }
    
    //MARK: View pesos colombianos
    @objc func longPress(press: UILongPressGestureRecognizer){
        if press.state == UIGestureRecognizerState.began{
            let touchPoint = press.location(in: self.table)
            if let indexPath = table.indexPathForRow(at: touchPoint){
                self.precioEnCOP.text = String(self.compras[indexPath.row].precioOriginal) + " " +  (self.compras[indexPath.row].moneda)!
                self.view.addSubview(ViewCOP)
                self.ViewCOP.center = self.view.center
            }
        }
        if press.state == UIGestureRecognizerState.ended{
            self.ViewCOP.removeFromSuperview()
        }
    }
    
}
