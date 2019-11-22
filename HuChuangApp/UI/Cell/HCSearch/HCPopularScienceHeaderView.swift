//
//  HCPopularScienceHeaderView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/3.
//  Copyright © 2019 sw. All rights reserved.
//  搜索界面科普文章section的header

import UIKit

public let HCPopularScienceHeaderView_identifier = "HCPopularScienceHeaderView"
class HCPopularScienceHeaderView: UITableViewHeaderFooterView {

    private var titleLabel: UILabel!
    private var topLine: UIView!
    
    public static var viewHeight: CGFloat = 44
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        topLine = UIView()
        topLine.backgroundColor = RGB(245, 245, 245)
        
        titleLabel = UILabel()
        titleLabel.font = .font(fontSize: 14, fontName: .PingFMedium)
        
        contentView.addSubview(topLine)
        contentView.addSubview(titleLabel)
        
        topLine.snp.makeConstraints {
            $0.left.right.top.equalTo(0)
            $0.height.equalTo(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
            $0.top.equalTo(topLine.snp.bottom).offset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
}
