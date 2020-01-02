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
    /// 医生等级 - 加号 - 擅长类型
    private var filiterDatas = (([TYFiliterModel](), [TYFiliterModel](), [TYFiliterModel]()))
    private var filiterCityDatas: HCCityItemModel?
    private var filiterOpType: Int = 0
    
    public let allCitysDataObser = Variable([HCAllCityItemModel]())
    public let filiterCommitSubject = PublishSubject<([TYFiliterModel], [TYFiliterModel], [TYFiliterModel])>()
    public let filiterCitySubject = PublishSubject<HCCityItemModel>()
    public let filiterOpTypeSubject = PublishSubject<Int>()
    
    public let searchTextObser = Variable("")
    public let requestSearchSubject = PublishSubject<Void>()
    
    override init() {
        super.init()
        
        let listDataTitle = ["全国", "咨询人数", "价格", "筛选"]
        for idx in 0..<listDataTitle.count {
            let model = TYListMenuModel()
            model.title = listDataTitle[idx]
  
            if idx == 0{
                model.titleIconNormalImage = UIImage.init(named: "btn_red_down_arrow")
                model.titleIconSelectedImage = UIImage.init(named: "btn_red_up_arrow")
                model.titleNormalColor = HC_MAIN_COLOR
            }else if idx == 1 || idx == 2 {
                model.titleSelectColor = RGB(153, 153, 153)
                model.titleIconNormalImage = UIImage.init(named: "btn_gray_down_arrow")
                model.titleIconSelectedImage = UIImage.init(named: "btn_gray_up_arrow")
            }else if idx == 3 {
                model.titleSelectColor = RGB(153, 153, 153)
                model.titleIconNormalImage = UIImage.init(named: "list_menu_filiter")
                model.titleIconSelectedImage = UIImage.init(named: "list_menu_filiter")
            }

            listMenuData.append(model)
        }
        
        filiterCitySubject
            .subscribe(onNext: { [weak self] in
                self?.filiterCityDatas = $0
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
        
        filiterCommitSubject
            .subscribe(onNext: { [weak self] in
                self?.filiterDatas = $0
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
        
        filiterCommitSubject
            .subscribe(onNext: { [weak self] _ in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
        
        filiterOpTypeSubject
            .subscribe(onNext: { [unowned self] in
                self.filiterOpType = $0
                self.requestData(true)
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.requestAllCitys()
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
        
        requestSearchSubject
            .subscribe(onNext: { [unowned self] in
                self.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    public func getListMenuData() ->[TYListMenuModel] {
        return listMenuData
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.consultSelectListPage(pageNum: pageModel.currentPage,
                                                  pageSize: pageModel.pageSize,
                                                  searchName: searchTextObser.value,
                                                  areaCode: filiterCityDatas?.id ?? "",
                                                  opType: prepareFiliterOpType(),
                                                  sceen: prepareSceen()))
            .map(model: HCExpertConsultListModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data.records, data.pages)
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
    
    private func requestAllCitys() {
        HCProvider.request(.allCity)
            .map(models: HCAllCityItemModel.self)
            .asObservable()
            .map({ datas -> [HCAllCityItemModel] in
                var tempDatas: [HCAllCityItemModel] = datas
                tempDatas.insert(HCAllCityItemModel.creatAll(), at: 0)
                return tempDatas
            })
            .bind(to: allCitysDataObser)
            .disposed(by: disposeBag)
    }
    
    private func prepareSceen() ->[String: Any] {
        var lv: [String] = []
        var addNum: [String] = []
        var skilledIn: [String] = []

        if filiterDatas.0.count > 0 {
            lv.append(contentsOf: filiterDatas.0.map{ $0.title })
        }
        
        if filiterDatas.1.count > 0 {
            addNum.append(contentsOf: filiterDatas.1.map{ $0.title })
        }

        if filiterDatas.2.count > 0 {
            skilledIn.append(contentsOf: filiterDatas.2.map{ $0.title })
        }
        
        return ["lv": lv, "addNum": addNum, "skilledIn": skilledIn]
    }
    
    private func prepareFiliterOpType() ->[String: Any] {
        let menuItem = listMenuData[filiterOpType]
        // desc = 1 倒序， 则 为正序
        let order: Int = menuItem.isSelected ? 1 : 0
        return ["type": filiterOpType, "desc": order]
    }
}
