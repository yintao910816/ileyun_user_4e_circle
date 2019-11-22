//
//  HCHomeCollectionHeaderReusableView.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/22.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

public let HCHomeCollectionHeaderReusableView_identifier = "HCHomeCollectionHeaderReusableView"

class HCHomeCollectionHeaderReusableView: UICollectionReusableView {

    @IBOutlet private var contentView: UICollectionReusableView!
    @IBOutlet private weak var carouselView: CarouselView!
    
    private var disposeBag = DisposeBag()

    public let bannerObser = PublishSubject<[HomeBannerModel]>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCHomeCollectionHeaderReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rxBind() {
        bannerObser
            .subscribe(onNext: { [weak self] data in
                self?.carouselView.setData(source: data)
            })
            .disposed(by: disposeBag)
    }
}
