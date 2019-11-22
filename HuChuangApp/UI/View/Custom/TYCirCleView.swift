//
//  TYCirCleView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/22.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class TYCirCleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        backgroundColor = .clear
        
        percent = 1.5
    }
    
    var percent: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let circleCenter = CGPoint.init(x: width/2.0, y: height/2.0)
        let lineWidth: CGFloat = 8.0
        let radius: CGFloat = width/2.0 - lineWidth
        
        context.beginPath()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(RGB(255, 255, 255, 0.4).cgColor)
                            
        let endAngle: CGFloat = 2 * CGFloat.pi
        context.addArc(center: circleCenter, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: false)
        context.strokePath()
        
        // 外圆
        let startAngle : CGFloat = 1.5 * CGFloat.pi
        var arcEndAngle: CGFloat = CGFloat(percent * CGFloat.pi)

        if percent > 0 {
            arcEndAngle = arcEndAngle >= 0.5 * CGFloat.pi ? arcEndAngle - 0.5 * CGFloat.pi : 2 * CGFloat.pi - arcEndAngle
        }else {
            arcEndAngle = startAngle
        }
        
        context.beginPath()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(RGB(255, 255, 255).cgColor)

        context.addArc(center: circleCenter, radius: radius, startAngle: startAngle, endAngle: arcEndAngle, clockwise: false)
        context.strokePath()
    }
}
