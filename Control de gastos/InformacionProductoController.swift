//
//  InformacionProductoController.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 8/26/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit
import CoreData

class InformacionProductoController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var tiendasTableView: UITableView!
    @IBOutlet var nombreProducto: UILabel!
    @IBOutlet var marcaProducto: UILabel!
    @IBOutlet var imagenProducto: UIImageView!
    
    var producto: Producto!
    var tiendas = [Tiendas]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagenProducto.isUserInteractionEnabled = true
        self.title = self.producto.nombre
        self.nombreProducto.text = self.producto.nombre
        self.marcaProducto.text = self.producto.marca
        if let tiendas = producto.tiendas as? Set<Tiendas> {
            self.tiendas = []
            for tienda in tiendas {
                self.tiendas.append(tienda)
            }
        }
        if let imagen = self.producto.image {
            self.imagenProducto.image = UIImage(data: imagen as Data)
        }
    }
    
    @IBAction func AddMarket(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Agregar Tienda", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Nombre de la tienda"
            textField.borderStyle = .roundedRect
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Precio"
            textField.borderStyle = .roundedRect
        }
        let saveButton = UIAlertAction(title: "Guardar", style: .default) { (_) in
            if alert.textFields?[0].text != "" && alert.textFields?[1].text != "" {
                let tienda = Tiendas(context: PersistenceService.context)
                tienda.tienda = alert.textFields?[0].text
                tienda.precio = Int32((alert.textFields?[1].text!)!)!
                self.producto.addToTiendas(tienda)
                self.tiendas.append(tienda)
                PersistenceService.saveContext()
                self.tiendasTableView.reloadData()
            }
        }
        let cancelButton = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(saveButton)
        present(alert, animated: true, completion: nil)
    }
    // MARK: Table View
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tiendas"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tiendas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tiendasTableView.dequeueReusableCell(withIdentifier: "Celda") as? InfoProductoCell else {
            fatalError("The dequeued cell is not an instance of InfoProductoCell")
        }
        cell.tienda.text = self.tiendas[indexPath.row].tienda
        cell.precio.text = "$ " + String(self.tiendas[indexPath.row].precio)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editButton = UITableViewRowAction(style: .normal, title: "Editar") { (rowAction, indexPath) in
            let alert = UIAlertController(title: "Editar tienda", message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = self.tiendas[indexPath.row].tienda
            })
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = String(self.tiendas[indexPath.row].precio)
            })
            let cancelbutton = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
            let saveButton = UIAlertAction(title: "Guardar", style: .default, handler: { (action) in
                self.tiendas[indexPath.row].tienda = alert.textFields?[0].text
                self.tiendas[indexPath.row].precio = Int32((alert.textFields?[1].text)!) ?? 0
                PersistenceService.saveContext()
                self.tiendasTableView.reloadData()
            })
            alert.addAction(cancelbutton)
            alert.addAction(saveButton)
            self.present(alert, animated: true, completion: nil)
        }
        editButton.backgroundColor = UIColor.blue
        
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Eliminar") { (rowAction, indexPath) in
            self.deleteMarket(at: indexPath)
            self.tiendas.remove(at: indexPath.row)
            self.tiendasTableView.reloadData()
        }
        return [deleteButton,editButton]
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{ fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set profile image to display selected image.
        imagenProducto.image = selectedImage
        
        self.producto.image = UIImagePNGRepresentation(selectedImage)! as NSData
        PersistenceService.saveContext()
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allows photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure PerfilController is notified when the user picks an image
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    // MARK: Funciones
    func deleteMarket(at indexPath: IndexPath) {
        let marketToDelete = self.tiendas[indexPath.row]
        PersistenceService.context.delete(marketToDelete)
        PersistenceService.saveContext()
    }

}
