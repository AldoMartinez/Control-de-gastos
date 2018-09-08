//
//  FirstLaunchController.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 8/29/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit

class FirstLaunchController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nombreUsuario: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        if nombreUsuario.text != "" {
            firstRun = false
            UserDefaults.standard.set(nombreUsuario.text, forKey: "nombreUsuario")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
            present(controller, animated: true, completion: nil)
        }else{
            self.nombreUsuario.placeholder = "Debes introducir tu nombre"
        }
    }
    // Funcion que desaparece el teclado cuando pulsas afuera de él
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
