//
//  HistorialCell.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 8/19/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit

class HistorialCell: UITableViewCell {
    
    @IBOutlet var compra: UILabel!
    @IBOutlet var precio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
