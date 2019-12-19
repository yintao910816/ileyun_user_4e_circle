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
    @IBOutlet weak var goDoctorOutlet: UIButton!
    @IBOutlet weak var paiNuanOutlet: UILabel!
    @IBOutlet weak var nextDayOutlet: UILabel!
    @IBOutlet weak var circleView: TYCirCleView!
    
    private var disposeBag = DisposeBag()

    public let bannerObser = PublishSubject<[HomeBannerModel]>()
    public var clickedMoreCallBack: (()->())?
    
    @IBAction func actions(_ sender: UIButton) {
        clickedMoreCallBack?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCHomeCollectionHeaderReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        addSubview(contentView)
        
        goDoctorOutlet.layer.borderColor = UIColor.white.cgColor
        goDoctorOutlet.layer.borderWidth = 2
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rxBind() {
        let paiNuanText = "距离排卵日还有0天"
        paiNuanOutlet.attributedText = paiNuanText.attributed(.init(location: 7, length: 2), .white, .font(fontSize: 21, fontName: .PingFMedium))
        
        let nextDayText = "明日好运率0%"
        nextDayOutlet.attributedText = nextDayText.attributed(.init(location: 5, length: 2), .white, .font(fontSize: 21, fontName: .PingFMedium))

        bannerObser
            .subscribe(onNext: { [weak self] data in
                self?.carouselView.setData(source: data)
            })
            .disposed(by: disposeBag)        
    }
    
    public var model: HCPregnancyProbabilityModel! {
        didSet {
            circleView.set(percent: model.todayProbability)
            
            let paiNuanText = "距离排卵日还有\(TYDateCalculate.numberOfDays(toDate: model.ovulationDate))天"
            paiNuanOutlet.attributedText = paiNuanText.attributed(.init(location: 7, length: 2), .white, .font(fontSize: 21, fontName: .PingFMedium))
            
            let nextDayText = "明日好运率\(model.tomorrowProbability)%"
            nextDayOutlet.attributedText = nextDayText.attributed(.init(location: 5, length: nextDayText.count - 5), .white, .font(fontSize: 21, fontName: .PingFMedium))
        }
    }
}
