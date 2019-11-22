


//
//  HCClassRoomListCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/28.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCClassRoomListCell_identifier = "HCClassRoomListCell"

class HCClassRoomListCell: UITableViewCell {

    @IBOutlet private weak var coverOutlet: UIImageView!
    @IBOutlet private weak var titleOutlet: UILabel!
    @IBOutlet private weak var desOutlet: UILabel!
    @IBOutlet private weak var timeOutlet: UILabel!
    @IBOutlet weak var viewCountOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: HomeArticleModel! {
        didSet {
            coverOutlet.setImage(model.picPath)
            titleOutlet.text = model.title
            desOutlet.text = model.info
            timeOutlet.text = model.publishDate
        }
    }
}
