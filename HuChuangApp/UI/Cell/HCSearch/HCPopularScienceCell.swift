//
//  HCPopularScienceCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/3.
//  Copyright © 2019 sw. All rights reserved.
//  搜索界面科普文章cell

import UIKit

public let HCPopularScienceCell_identifier = "HCPopularScienceCell"
class HCPopularScienceCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    
    public static var cellHeight: CGFloat = 75

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public var model: HCPopularScienceModel! {
        didSet {
            titleOutlet.text = model.title
            desOutlet.text = model.praise
        }
    }
}
