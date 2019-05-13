//
//  TableViewCellPhones.swift
//  S.E.P
//
//  Created by Artem Golovanev on 11.05.2019.
//  Copyright © 2019 Artem Golovanev. All rights reserved.
//

import UIKit

class TableViewCellPhones: UITableViewCell {

    @IBOutlet weak var imageViewPhones: UIImageView!
    @IBOutlet weak var labelPhonesName: UILabel!
    @IBOutlet weak var labelPricePhone: UILabel!
    var descr: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
