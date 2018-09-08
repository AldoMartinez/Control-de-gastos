//
//  Compra+CoreDataProperties.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 9/5/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//
//

import Foundation
import CoreData


extension Compra {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Compra> {
        return NSFetchRequest<Compra>(entityName: "Compra")
    }

    @NSManaged public var fecha: NSDate?
    @NSManaged public var moneda: String?
    @NSManaged public var nombre: String?
    @NSManaged public var precio: Double
    @NSManaged public var precioOriginal: Double

}
