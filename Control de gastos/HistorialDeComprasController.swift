//
//  HistorialDeComprasController.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 8/15/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit
import CoreData

class HistorialDeComprasController: UITableViewController{
    var compras = [Compra]()
    var fechas = [NSDate:[Compra]]()
    var onlyDates = [NSDate]()
    var fecha: String!
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle = .medium
        self.fecha = formatter.string(from: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<Compra> = Compra.fetchRequest()
        
        do{
            var compras = try PersistenceService.context.fetch(fetchRequest)
            self.compras = compras
            for compra in self.compras {
                if !onlyDates.contains(compra.fecha!){
                    onlyDates.append(compra.fecha!)
                }
                compras.append(compra)
                var list = self.fechas[compra.fecha!] ?? []
                list.append(compra)
                self.fechas[compra.fecha!] = list
            }
        }catch{}
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let date = self.onlyDates[section]
            return (self.fechas[date]?.count)!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fechas.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        formatter.dateStyle = .medium
        return formatter.string(from: self.onlyDates[section] as Date)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! HistorialCell
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "celda")
        let date = self.onlyDates[indexPath.section]
        cell.compra.text = self.fechas[date]![indexPath.row].nombre
        cell.precio.text = "$" + String(format:"%.2f",self.fechas[date]![indexPath.row].precio) + "MXN"
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 25))
        view.backgroundColor = UIColor(displayP3Red: 81.0/255.0, green: 132.0/255.0, blue: 234.0/255.0, alpha: 0.7)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: 25))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.white
        label.text = formatter.string(from: self.onlyDates[section] as Date)
        view.addSubview(label)
        return view
    }
}







