//
//  ExchangeRate+CoreDataProperties.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 8/19/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//
//

import Foundation
import CoreData


extension ExchangeRate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExchangeRate> {
        return NSFetchRequest<ExchangeRate>(entityName: "ExchangeRate")
    }

    @NSManaged public var change: Double

}
