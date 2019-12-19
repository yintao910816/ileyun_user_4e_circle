//
//  HCExpertConsultViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/29.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCExpertConsultViewModel: RefreshVM<HCDoctorItemModel> {
    
    private var listMenuData: [TYListMenuModel] = []
    private var filiterDatas = (([TYFiliterModel](), [TYFiliterModel](), [TYFiliterModel]()))
    private var filiterCityDatas: HCCityItemModel?
    
    public let allCitysDataObser = Variable([HCAllCityItemModel]())
    public let filiterCommitSubject = PublishSubject<([TYFiliterModel], [TYFiliterModel], [TYFiliterModel])>()
    public let filiterCitySubject = PublishSubject<HCCityItemModel>()
    
    override init() {
        super.init()
        
        let listDataTitle = ["全国", "咨询人数", "价格", "筛选"]
        for idx in 0..<listDataTitle.count {
            let model = TYListMenuModel()
            model.title = listDataTitle[idx]
            model.isSelected = idx == 0
//            if idx == 0 || idx == 2{
//                model.titleIconNormalImage = UIImage.init(named: "btn_gray_down_arrow")
//            }else if idx == 3 {
//                model.titleIconCanRotate = false
//                model.titleIconNormalImage = UIImage.init(named: "list_menu_filiter")
//                model.titleIconSelectedImage = UIImage.init(named: "list_menu_filiter")
//            }
  
            if idx == 0{
                model.titleIconNormalImage = UIImage.init(named: "btn_gray_down_arrow")
                model.isSelected = true
                model.titleIconCanRotate = true
            }else if idx == 1 || idx == 2 {
                model.titleIconCanRotate = false
            }else if idx == 3 {
                model.titleIconCanRotate = false
                model.titleSelectColor = RGB(153, 153, 153)
                model.titleIconNormalImage = UIImage.init(named: "list_menu_filiter")
                model.titleIconSelectedImage = UIImage.init(named: "list_menu_filiter")
            }

            listMenuData.append(model)
        }
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.requestAllCitys()
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    public func getListMenuData() ->[TYListMenuModel] {
        return listMenuData
    }
    
    override func requestData(_ refresh: Bool) {
        HCProvider.request(.consultSelectListPage(pageNum: 1, pageSize: 10, searchName: "", areaCode: 0, opType: 0, sceen: ""))
            .map(model: HCExpertConsultListModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data.records, data.pages)
            }) { [weak self] error in
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
    
    private func requestAllCitys() {
        HCProvider.request(.allCity)
            .map(models: HCAllCityItemModel.self)
            .asObservable()
            .bind(to: allCitysDataObser)
            .disposed(by: disposeBag)
    }
}
