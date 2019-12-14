//
//  TYColorLineView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/14.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class TYColorLineView: UIView {

    private var lineView: UIView!
    
    private var itemDatas: [TYLineItemModel] = []
    var pointDatas: [TYPointItemModel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lineView = UIView.init(frame: bounds)
        lineView.backgroundColor = .white
        addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(itemDatas: [TYLineItemModel], pointDatas: [TYPointItemModel]) {
        self.itemDatas.removeAll()
        self.itemDatas.append(contentsOf: itemDatas)
        self.pointDatas = pointDatas
        
        var rect = lineView.frame
        rect.size.width = width
        lineView.frame = rect
        
        setupLine()
    }
    
    private func setupLine() {
        let linePath = UIBezierPath.init()
        linePath.move(to: .init(x: 0, y: 0))
        linePath.addLine(to: .init(x: width, y: 0))
        
        var strokeStart: CGFloat = 0
        for data in itemDatas {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = linePath.cgPath
            shapeLayer.lineWidth = 2 * lineView.height
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = data.color.cgColor
            shapeLayer.strokeStart = strokeStart
            
            let strokeEnd: CGFloat = strokeStart + data.percentage
            shapeLayer.strokeEnd = strokeEnd
            
            lineView.layer.addSublayer(shapeLayer)
            
            strokeStart = strokeEnd
        }
        
        let pointSize: CGFloat = 2 * lineView.height
        let pointMargin: CGFloat = lineView.width / CGFloat(pointDatas.count)
        var pointX: CGFloat = 0.0
        for data in pointDatas {
            let pointV = UIImageView.init(frame: .init(x: pointX, y: -lineView.height, width: pointSize, height: pointSize))
            pointV.backgroundColor = .white
            pointV.clipsToBounds = true
            pointV.layer.cornerRadius = pointSize / 2
            pointV.layer.borderColor = data.borderColor.cgColor
            pointV.layer.borderWidth = 1
            lineView.addSubview(pointV)
            
            pointX += (pointMargin - pointSize / 2.0)
        }
    }
}

struct TYLineItemModel {
    /// 每一段的颜色
    var color: UIColor = .white
    /// 每一段所占据的总宽度百分比
    var percentage: CGFloat = 0
}

struct TYPointItemModel {
    var borderColor: UIColor = .clear
}
