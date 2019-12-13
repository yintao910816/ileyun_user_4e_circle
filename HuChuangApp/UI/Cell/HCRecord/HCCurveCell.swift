//
//  HCCurveCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/13.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCCurveCell_identifier = "HCCurveCell"
public let HCCurveCell_height: CGFloat = TYCurveView.viewHeight

class HCCurveCell: UICollectionViewCell {
    
    private var curveView: TYCurveView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        curveView = TYCurveView()
        curveView.backgroundColor = .lightGray
        contentView.addSubview(curveView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(probabilityDatas: [Float], titmesDatas: [String]) {
        curveView.setData(probabilityDatas: probabilityDatas, titmesDatas: titmesDatas)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        curveView.frame = contentView.bounds
    }
}
