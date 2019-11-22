//
//  MineHeader.swift
//  HuChuangApp
//
//  Created by yintao on 2019/2/13.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MineHeaderView: UIView {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var userIconOutlet: UIButton!
    @IBOutlet weak var nickNameOutlet: UILabel!
    @IBOutlet weak var focusCountOutlet: UILabel!
    @IBOutlet weak var cornerBgView: UIView!
    
    @IBOutlet weak var titleTopCns: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    
    let userModel = PublishSubject<HCUserModel>()
    let gotoEditUserInfo = PublishSubject<Void>()
    let openH5Publish = PublishSubject<H5Type>()
    let gotoSetting = PublishSubject<Void>()

    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 200:
            // 设置
            gotoSetting.onNext(Void())
        case 201:
            // 通知
            openH5Publish.onNext(.consultRecord)
        case 202:
            // 我的医生
            openH5Publish.onNext(.memberCollect)
        case 203:
            // 我的问诊
            openH5Publish.onNext(.memberCollect)
        case 204:
            // 关注的医生
            openH5Publish.onNext(.memberCollect)
        default:
            break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("MineHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
                
        if UIDevice.current.isX {
            var frame = contentView.frame
            frame.size.height += LayoutSize.topVirtualArea
            contentView.frame = frame
            
            titleTopCns.constant += LayoutSize.fitTopArea
        }

        
        setupUI()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let attr = "0\n关注".attributed(.init(location: 2, length: 2), RGB(255, 209, 218), .font(fontSize: 14, fontName: .PingFLight))
        focusCountOutlet.attributedText = attr
    }
    
    private func rxBind() {
        userIconOutlet.rx.tap.asObservable()
            .bind(to: gotoEditUserInfo)
            .disposed(by: disposeBag)
        
        userModel.subscribe(onNext: { [unowned self] user in
            self.userIconOutlet.setImage(user.headPath, .userIcon)
            self.nickNameOutlet.text = user.name
        })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cornerBgView.set(cornerRadius: 8, borderCorners: [.topLeft, .topRight])
    }
}
