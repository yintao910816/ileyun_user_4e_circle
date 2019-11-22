//
//  HCSearchFooterView.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/3.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCSearchFooterView_identifier = "HCSearchFooterView"

class HCSearchFooterView: UITableViewHeaderFooterView {

    private var titleButton: UIButton!
    
    public class var viewHeight: CGFloat {
        return 52
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        titleButton = UIButton.init(type: .custom)
        titleButton.setTitleColor(RGB(153, 153, 153), for: .normal)
        titleButton.titleLabel?.font = .font(fontSize: 14)
        addSubview(titleButton)
        
        titleButton.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var contentText: String = "" {
        didSet {
            titleButton.setTitle(contentText, for: .normal)
        }
    }
}
