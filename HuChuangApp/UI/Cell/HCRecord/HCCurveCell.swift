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

class HCCurveCell: HCBaseRecordCell {
    
    private var curveView: TYCurveView!
    
    public var fullScreenCallBack: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var model: HCRecordData! {
        didSet {
            guard let proModel = model as? HCRecordItemDataModel else {
                return
            }
            
            if curveView != nil { curveView.removeFromSuperview() }
            
            curveView = TYCurveView.init(frame: bounds)
            curveView.backgroundColor = .white
            contentView.addSubview(curveView)
            
            curveView.fullScreenCallBack = { [unowned self] in
                self.fullScreenCallBack?()
            }

            curveView.setData(probabilityDatas: proModel.probabilityDatas,
                              itemDatas: proModel.lineItemDatas,
                              title: proModel.isContrast ? proModel.nowCircle : proModel.curelTitle)
        }
    }
        
}
