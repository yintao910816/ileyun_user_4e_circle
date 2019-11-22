//
//  HCConsultListCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/25.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCConsultListCell_idetifier = "HCConsultListCell"

class HCConsultListCell: UITableViewCell {

    @IBOutlet weak var coverOutlet: UIButton!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var workerOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var infoOutlet: UILabel!
    @IBOutlet weak var adeptOutlet: UILabel!
    
    @IBOutlet weak var scoreOutlet: UILabel!
    @IBOutlet weak var anwserCountOutlet: UILabel!
    
    @IBOutlet weak var labelContainer: UIView!
    
    @IBOutlet weak var labelContainerHeightCns: NSLayoutConstraint!
    @IBOutlet weak var infoTopCns: NSLayoutConstraint!
    @IBOutlet weak var adeptTopCns: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model: HCDoctorItemModel! {
        didSet {
            coverOutlet.setImage(model.headPath)
            nameOutlet.text = model.userName
            workerOutlet.text = model.technicalPost
            priceOutlet.text = model.priceText
            infoOutlet.text = model.unitName
            adeptOutlet.text = model.skilledIn
            scoreOutlet.text = model.reviewNum
            anwserCountOutlet.text = model.anwserCountText
            
            infoTopCns.constant = model.infoTopMargin
            adeptTopCns.constant = model.adeptTopMargin
            
            for item in labelContainer.subviews { item.removeFromSuperview() }
            
            if model.labels.count > 0 {
                for idx in 0..<model.labels.count {
                    let label = UILabel()
                    label.numberOfLines = 0
                    label.textColor = RGB(255, 102, 149)
                    label.font = .font(fontSize: 14)
                    label.layer.borderWidth = 1
                    label.layer.borderColor = RGB(255, 102, 149).cgColor
                    label.textAlignment = .center
                    label.text = model.labels[idx]
                    label.tag  = 200 + idx
                    labelContainer.addSubview(label)
                }
            }else {
                labelContainerHeightCns.constant = 0
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelContainerHeightCns.constant = model.labelContainerHeight

        for idx in 0..<model.labels.count {
            if idx < model.labelFrames.count,
                let label = labelContainer.viewWithTag(200 + idx)
            {
                let lFrame = model.labelFrames[idx]
                label.frame = lFrame
                label.layer.cornerRadius = lFrame.height / 2.0
            }
        }
    }
}
