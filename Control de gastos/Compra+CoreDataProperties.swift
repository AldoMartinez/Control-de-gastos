//
//  Compra+CoreDataProperties.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 8/15/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//
//

import Foundation
import CoreData


extension Compra {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Compra> {
        return NSFetchRequest<Compra>(entityName: "Compra")
    }

    @NSManaged public var fecha: String?
    @NSManaged public var precio: Double
    @NSManaged public var nombre: String?
    @NSManaged public var precioOriginal: Double
    @NSManaged public var moneda: String?

}
