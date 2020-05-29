//
//  ConsoleTableViewCell.swift
//  MyGames
//
//  Created by Jaciel Ferreira da Siva on 28/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class ConsoleTableViewCell: UITableViewCell {
   
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var IvCover: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
