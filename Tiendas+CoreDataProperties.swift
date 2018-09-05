//
//  Tiendas+CoreDataProperties.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 8/22/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//
//

import Foundation
import CoreData


extension Tiendas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tiendas> {
        return NSFetchRequest<Tiendas>(entityName: "Tiendas")
    }

    @NSManaged public var idProducto: Int16
    @NSManaged public var tienda: String?
    @NSManaged public var precio: Int32
    @NSManaged public var producto: Producto?

}
