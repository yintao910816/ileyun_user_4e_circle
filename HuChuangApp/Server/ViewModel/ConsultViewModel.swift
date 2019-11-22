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
        
//        HCProvider.request(.unitSetting(type: .patientConsult))
//            .map(model: H5InfoModel.self)
//            .map { model -> String in
//                guard model.setValue.count > 0 else { return "" }
//                let url = "\(model.setValue)?token=\(userDefault.token)&unitId=\(userDefault.unitId)"
//                return url
//            }
//            .asObservable()
//            .bind(to: webRefreshSubject)
//            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.consultList(pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(model: HCDoctorModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data.records, data.pages)
            }) { [weak self] error in
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
}
