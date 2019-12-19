//
//  TYListMenuData.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/28.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

enum TYListArrowType {
    case up
    case down
}

class TYListMenuModel {
    var title: String = ""
    var titleFont: UIFont = .font(fontSize: 13, fontName: .PingFRegular)
    var titleNormalColor: UIColor = RGB(153, 153, 153)
    var titleSelectColor: UIColor = HC_MAIN_COLOR
    var isAutoWidth: Bool = true
    
    var titleIconNormalImage: UIImage?
    var titleIconSelectedImage: UIImage?
    
    var arrowDownImage: UIImage? = UIImage(named: "btn_red_down_arrow")
    var arrowUpImage: UIImage? = UIImage(named: "btn_red_up_arrow")

    var titleIconCanRotate: Bool = true
    
    var arrowType: TYListArrowType = .down
    
    var iconMargin: CGFloat = 5
    var margin: CGFloat = 15

    var isSelected: Bool = false
    
    var titleWidth: CGFloat {
        get {
            return self.title.ty_textSize(font: self.titleFont, width: CGFloat(MAXFLOAT), height: 30).width
        }
    }
    
    var titleColor: UIColor {
        get {
            return isSelected ? titleSelectColor : titleNormalColor
        }
    }
    
    var titleImage: UIImage? {
        get {
            if titleIconCanRotate {
                if isSelected {
                    return arrowType == .up ? arrowUpImage : arrowDownImage
                }
            }
            return titleIconNormalImage
        }
    }

    public func didClicked(_ isReset: Bool = true) {
        if isReset {
            arrowType = .down
            isSelected = false
        }else {
            isSelected = true
            arrowType = (arrowType == .up ? .down : .up)
        }
    }
    
    public func resetStatus() {
        
    }
    
    class func creat(with title: String,
                     titleFont: UIFont = .font(fontSize: 13, fontName: .PingFRegular),
                     titleNormalColor: UIColor = RGB(153, 153, 153),
                     titleSelectColor: UIColor = HC_MAIN_COLOR,
                     isSelected: Bool = false,
                     titleIconNormalImage:UIImage? = nil,
                     titleIconSelectedImage:UIImage? = nil,
                     titleIconCanRotate: Bool = true,
                     iconMargin: CGFloat = 5,
                     margin: CGFloat = 15) ->TYListMenuModel
    {
        let model = TYListMenuModel()
        model.title = title
        model.titleFont = titleFont
        model.titleNormalColor = titleNormalColor
        model.titleNormalColor = titleSelectColor
        model.isSelected = isSelected
        model.titleIconNormalImage = titleIconNormalImage
        model.titleIconSelectedImage = titleIconSelectedImage
        model.titleIconCanRotate = titleIconCanRotate
        model.iconMargin = margin
        model.margin = margin

        return model
    }
}
