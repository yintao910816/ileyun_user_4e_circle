//
//  HCSearchViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/3.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class HCSearchViewModel: RefreshVM<HCBaseSearchItemModel> {
        
    private var menuPageListData: [HCsearchModule: [HCBaseSearchItemModel]] = [:]
    // 记录当前第几页数据
    private var module: HCsearchModule = .all

    public let keyWordObser = Variable("")
    public let pageListData = PublishSubject<([HCBaseSearchItemModel], HCsearchModule)>()
    public let requestSearchListSubject = PublishSubject<HCsearchModule>()
    /// 关键字搜索 - 是否添加到本地数据库
    public let requestSearchSubject = PublishSubject<Bool>()
    /// 清除本地缓存记录
    public let clearSearchRecordSubject = PublishSubject<Void>()
    public let selectedSearchRecordSubject = PublishSubject<String>()

    /// 本地搜索记录
    public let searchRecordsObser = Variable([TYSearchSectionModel]())
    
    override init() {
        super.init()
                
        TYSearchRecordModel.selected { [weak self] records in
            self?.searchRecordsObser.value = TYSearchSectionModel.recordsCreate(datas: records)
        }
        
        requestSearchListSubject
            .subscribe(onNext: { [unowned self] module in
                self.module = module
                if let list = self.menuPageListData[module] {
                    self.pageListData.onNext((list, module))
                }else {
                    self.requestData(true)
                }
            })
            .disposed(by: disposeBag)
        
        requestSearchSubject
            .subscribe(onNext: { [unowned self] cache in
                if cache { self.cacheSearchRecord() }
                self.requestData(true)
            })
            .disposed(by: disposeBag)
        
        clearSearchRecordSubject
            .subscribe(onNext: { [weak self] in
                self?.clearSearchRecords()
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
        
        selectedSearchRecordSubject
            .subscribe(onNext: { [unowned self] keyWord in
                self.keyWordObser.value = keyWord
                self.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        
        updatePage(for: module.rawValue, refresh: refresh)
        
        let requestProvider = HCProvider.request(.search(pageNum: currentPage(for: module.rawValue),
                                                         pageSize: pageSize(for: module.rawValue),
                                                         searchModule: module,
                                                         searchName: keyWordObser.value))
        
        switch module {
        case .all:
            requestProvider
                .map(model: HCSearchDataModel.self)
                .subscribe(onSuccess: { [weak self] in self?.dealSuccess(data: $0, refresh: refresh) },
                           onError: { [weak self] in self?.dealFailure(error: $0) })
                .disposed(by: disposeBag)
        case .article:
            requestProvider
                .map(model: HCSearchArticleModel.self)
                .subscribe(onSuccess: { [weak self] in self?.dealSuccess(data: $0, refresh: refresh) },
                           onError: { [weak self] in self?.dealFailure(error: $0) })
                .disposed(by: disposeBag)
        case .course:
            requestProvider
                .map(model: HCSearchCourseModel.self)
                .subscribe(onSuccess: { [weak self] in self?.dealSuccess(data: $0, refresh: refresh) },
                           onError: { [weak self] in self?.dealFailure(error: $0) })
                .disposed(by: disposeBag)
        case .doctor:
            requestProvider
                .map(model: HCSearchDoctorModel.self)
                .subscribe(onSuccess: { [weak self] in self?.dealSuccess(data: $0, refresh: refresh) },
                           onError: { [weak self] in self?.dealFailure(error: $0) })
                .disposed(by: disposeBag)
        }
    }

}

extension HCSearchViewModel {
    
    private func dealSuccess(data: HCBaseSearchItemModel, refresh: Bool) {
        if menuPageListData[module] == nil {
            menuPageListData[module] = [HCBaseSearchItemModel]()
        }
        
        var datas = [HCBaseSearchItemModel]()
        switch module {
        case .all:
            datas = [data]
        case .article:
            datas = (data as! HCSearchArticleModel).records
        case .doctor:
            datas = (data as! HCSearchDoctorModel).records
        case .course:
//            datas = (data as! HCSearchCourseModel).records
            break
        }
        
        updateRefresh(refresh: refresh,
                      models: datas,
                      dataModels: &(menuPageListData[module])!,
                      pages: data.pages,
                      pageKey: module.rawValue)
        
        pageListData.onNext((menuPageListData[module]!, module))
        
        if keyWordObser.value.count > 0 {
            hud.noticeHidden()
        }
    }
    
    private func dealFailure(error: Error) {
        if keyWordObser.value.count > 0 {
            hud.failureHidden(errorMessage(error))
        }else {
            revertCurrentPageAndRefreshStatus(pageKey: module.rawValue)
        }
    }
    
    private func cacheSearchRecord() {
        if keyWordObser.value.count > 0 {
            var datas = searchRecordsObser.value
            if datas.count == 1 {
                let sectionModel = TYSearchSectionModel.creatSection(sectionTitle: "搜索记录", showDelete: true)
                sectionModel.addRecord(keyWord: keyWordObser.value)
                datas.insert(sectionModel, at: 0)
                
            }else {
                datas.first!.addRecord(keyWord: keyWordObser.value)
            }
            
            searchRecordsObser.value = datas
            
            TYSearchRecordModel.insert(keyWord: keyWordObser.value)
        }
    }
    
    private func clearSearchRecords() {
        var datas = searchRecordsObser.value
        if datas.count > 1 {
            datas.remove(at: 0)
        }
        
        searchRecordsObser.value = datas
        
        TYSearchRecordModel.clearSearchRecords()
    }
}
