//
//  Producto+CoreDataProperties.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 9/1/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//
//

import Foundation
import CoreData


extension Producto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Producto> {
        return NSFetchRequest<Producto>(entityName: "Producto")
    }

    @NSManaged public var idProducto: Int16
    @NSManaged public var marca: String?
    @NSManaged public var nombre: String?
    @NSManaged public var image: NSData?
    @NSManaged public var tiendas: NSSet?

}

// MARK: Generated accessors for tiendas
extension Producto {

    @objc(addTiendasObject:)
    @NSManaged public func addToTiendas(_ value: Tiendas)

    @objc(removeTiendasObject:)
    @NSManaged public func removeFromTiendas(_ value: Tiendas)

    @objc(addTiendas:)
    @NSManaged public func addToTiendas(_ values: NSSet)

    @objc(removeTiendas:)
    @NSManaged public func removeFromTiendas(_ values: NSSet)

}
