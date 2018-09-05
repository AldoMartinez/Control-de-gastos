//
//  ListaDeProductosController.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 8/24/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit
import CoreData

class ListaDeProductosController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet var productosTableView: UITableView!
    var productos: [Producto] = []
    var productoActual: [Producto] = []
    let topOffset: CGFloat = 64
    var indexPath = IndexPath()

    @IBOutlet var searchBar: UISearchBar!
    @IBAction func AddProduct(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "", message: "Agrega Producto", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Nombre del producto"
            textField.borderStyle = .roundedRect
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Marca"
            textField.borderStyle = .roundedRect
        }
        let cancelButton = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        let addProductButton = UIAlertAction(title: "Agregar", style: .default) { (action) in
            if alert.textFields?[0].text != "" {
                let producto = Producto(context: PersistenceService.context)
                producto.nombre = alert.textFields?[0].text
                producto.marca = alert.textFields?[1].text
                PersistenceService.saveContext()
                self.productos.append(producto)
                self.productoActual = self.productos
            }
            self.productosTableView.reloadData()
        }
        alert.addAction(cancelButton)
        alert.addAction(addProductButton)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Funciones
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    override func viewWillAppear(_ animated: Bool) {
        self.productos = []
        let fetchProductos: NSFetchRequest<Producto> = Producto.fetchRequest()
        do {
            let productos = try PersistenceService.context.fetch(fetchProductos)
            for producto in productos {
                self.productos.append(producto)
            }
            self.productoActual = self.productos
            self.productosTableView.reloadData()
        }catch{
            print(error)
        }
        self.searchBar.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteProduct(at indexPath: IndexPath) {
        let productToDelete = self.productoActual[indexPath.row]
        PersistenceService.context.delete(productToDelete)
        PersistenceService.saveContext()
    }
    
    // Funcion que desaparece el teclado cuando pulsas afuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.searchBar.endEditing(true)
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.productoActual.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath)

        cell.textLabel?.text = self.productoActual[indexPath.row].nombre
        cell.detailTextLabel?.text = self.productoActual[indexPath.row].marca
        cell.textLabel?.font = UIFont(name: "Helvetica Neue Light", size: 17.0)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "InformacionProductoController") as? InformacionProductoController
        vc?.producto = self.productoActual[indexPath.row]
//        self.navigationController?.pushViewController(vc!, animated: true)
        self.navigationController?.show(vc!, sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        self.indexPath = indexPath
        let editButton = UITableViewRowAction(style: .normal, title: "Editar") { (rowAction, indexPath) in
            // Crea una instancia de EditarProductoController y le pasamos el producto seleccionado
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditarProductoController") as? EditarProductoController
            controller?.productToEdit = self.productoActual[indexPath.row]
            // Crea un navigationController para la instancia anterior
            let navigationController = UINavigationController(rootViewController: controller!)
            navigationController.navigationBar.barStyle = .black
            self.present(navigationController, animated: true, completion: nil)
        }
        editButton.backgroundColor = UIColor.blue
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Eliminar") { (rowAction, indexPath) in
            self.deleteProduct(at: indexPath)
            self.productoActual.remove(at: indexPath.row)
            self.productosTableView.reloadData()
        }
        return [deleteButton,editButton]
    }
    

    
    // MARK: Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.productoActual = self.productos
            self.productosTableView.reloadData()
            print(self.productoActual)
            return
        }
        let productosPorNombre = self.productos.filter({ (producto) -> Bool in
            (producto.nombre?.lowercased().contains(searchText.lowercased()))!
        })
        let productosPorMarca = self.productos.filter { (producto) -> Bool in
            (producto.marca?.lowercased().contains(searchText.lowercased()))!
        }
        self.productoActual = []
        self.productoActual = productosPorNombre
        for producto in productosPorMarca {
            if !self.productoActual.contains(producto) {
                self.productoActual.append(producto)
            }
        }
        self.productosTableView.reloadData()
    }

    
}
