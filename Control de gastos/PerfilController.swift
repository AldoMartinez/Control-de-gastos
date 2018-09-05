//
//  PerfilController.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 7/31/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit
import CoreData

class PerfilController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var gastoTotal: UILabel!
    @IBOutlet weak var nombreUsuario: UILabel!
    var compras = [Compra]()
    var fecha: String!
    var formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle = .medium
        self.fecha = formatter.string(from: Date())
        // Do any additional setup after loading the view.
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.layer.masksToBounds = true
        profileImage.isUserInteractionEnabled = true
        self.nombreUsuario.text = UserDefaults.standard.string(forKey: "nombreUsuario")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Se hace la peticion para recuperar los datos guardados
        let fetchRequest: NSFetchRequest<Compra> = Compra.fetchRequest()
//        let fetch2: NSFetchRequest<Producto> = Producto.fetchRequest()
        do{
//            let productos = try PersistenceService.context.fetch(fetch2)
//            if let producto = productos.first {
//                print(producto.nombre!)
//                if let tiendas = producto.tiendas as? Set<Tiendas> {
//                    for tienda in tiendas {
//                        print("\(tienda.tienda) - \(tienda.precio)")
//                    }
//                }
//            }
//            let producto = try PersistenceService.context.fetch(fetch2)
//            for product in producto {
//                let tiendasRegistradas = product.tiendas
//                print(tiendasRegistradas)
//
//            }
            let compras = try PersistenceService.context.fetch(fetchRequest)
            self.compras = compras
            var sumaTotal = 0.0
            for compra in self.compras {
                if compra.fecha == self.fecha {
                    sumaTotal += compra.precio
                }
                
            }
            self.gastoTotal.text = "Gasto del día: $" + String(format: "%.2f", sumaTotal)
        }catch{}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        profileImage.image = selectedImage
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

