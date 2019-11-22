//
//  HCSearchDoctorCourseCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/3.
//  Copyright © 2019 sw. All rights reserved.
//  搜索课程

import UIKit

public let HCSearchDoctorCourseCell_identifier = "HCSearchDoctorCourseCell"

class HCSearchDoctorCourseCell: UITableViewCell {

    @IBOutlet weak var courseTypeOutlet: UILabel!
    @IBOutlet weak var couseBriefOutlet: UILabel!
    @IBOutlet weak var doctorIconOutlet: UIButton!
    @IBOutlet weak var doctorNameOutlet: UILabel!
    @IBOutlet weak var doctorJobOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public var model: HCSearchDoctorCourseModel! {
        didSet {
            courseTypeOutlet.text = model.courseType
            couseBriefOutlet.text = model.couseBrief
            doctorNameOutlet.text = model.doctorName
            doctorJobOutlet.text = model.doctorJob
        }
    }
}
