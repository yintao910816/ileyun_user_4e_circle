//
//  HCHomeFuncItemCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/22.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCHomeFuncItemCell_identifier = "HCHomeFuncItemCell"

class HCHomeFuncItemCell: UICollectionViewCell {

    @IBOutlet weak var iconOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: HomeFunctionModel! {
        didSet {
            iconOutlet.setImage(model.iconPath)
            titleOutlet.text = model.name
        }
    }
}
