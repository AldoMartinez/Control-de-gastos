//
//  EditarProductoController.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 8/27/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit

class EditarProductoController: UITableViewController {
    
    @IBOutlet var productName: UITextField!
    @IBOutlet var productBrand: UITextField!
    
    var productToEdit: Producto!

    override func viewDidLoad() {
        super.viewDidLoad()
        productName.text = productToEdit.nombre
        productBrand.text = productToEdit.marca
        
        // Agregamos los botones al navigation item
        let cancelbutton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelEditing))
        let doneButton = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(doneEditing))
        self.navigationItem.leftBarButtonItem = cancelbutton
        self.navigationItem.rightBarButtonItem = doneButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func cancelEditing(){
        self.dismiss(animated: true, completion: nil)
    }
    // Funcion que guarda los cambios hecho al producto
    @objc func doneEditing() {
        self.productToEdit.nombre = self.productName.text
        self.productToEdit.marca = self.productBrand.text
        PersistenceService.saveContext()
        self.dismiss(animated: true, completion: nil)
    }


}
