//
//  Sale.swift
//  Control de gastos
//
//  Created by Aldo Aram Martinez Mireles on 7/31/18.
//  Copyright © 2018 Aldo Aram Martinez Mireles. All rights reserved.
//

import UIKit

class ResumenDiarioCell: UITableViewCell {
    
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
