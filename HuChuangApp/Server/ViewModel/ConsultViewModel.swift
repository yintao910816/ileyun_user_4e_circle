//
//  ConsultViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/8/14.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class ConsultViewModel: RefreshVM<HCDoctorItemModel> {
    
    let webRefreshSubject = PublishSubject<String>()
    
    override init() {
        super.init()
                
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.recommendDoctor(areaCode: 2700))
            .map(models: HCDoctorItemModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data, data.count)
            }) { [weak self] error in
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
}
