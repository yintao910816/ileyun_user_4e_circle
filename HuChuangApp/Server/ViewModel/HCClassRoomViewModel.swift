//
//  HCClassRoomViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/28.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCClassRoomViewModel: RefreshVM<HomeArticleModel> {
    
    private var columnData: HomeColumnModel!
    private var menuPageListData: [Int: [HomeArticleModel]] = [:]
    
    public let requestTodayListSubject = PublishSubject<Int>()
    
    public let menuItemData = PublishSubject<[TYSlideItemModel]>()
    public let pageListData = PublishSubject<([HomeArticleModel], Int)>()

    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [unowned self] in self.requestColumnData() })
            .disposed(by: disposeBag)
        
        requestTodayListSubject
            .subscribe(onNext: { [unowned self] page in
                self.requestTodayList(item: self.columnData.content[page], page: page)
            })
            .disposed(by: disposeBag)
    }
    
    /// 滚动菜单
    private func requestColumnData() {
        HCProvider.request(.column(cmsType: .webCms001))
            .map(model: HomeColumnModel.self)
            .subscribe(onSuccess: { [weak self] model in
                self?.columnData = model
                
                self?.menuItemData.onNext(TYSlideItemModel.mapData(models: model.content))
                
                if model.content.count > 0 {
                    self?.requestTodayList(item: model.content.first!, page: 0)
                }
            }) { error in
                
        }
        .disposed(by: disposeBag)
    }
    
    /// 获取菜单栏列表数据
    private func requestTodayList(item: HomeColumnItemModel, page: Int) {
        if let list = menuPageListData[page] {
            pageListData.onNext((list, page))
            return
        }
        
        HCProvider.request(.articlePage(id: item.id, pageNum: currentPage(for: "\(item.id)"), pageSize: pageSize(for: "\(item.id)")))
            .map(models: HomeArticleModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.menuPageListData[page] = data
                self?.pageListData.onNext((data, page))
            }) { error in
                
        }
        .disposed(by: disposeBag)

//        HCProvider.request(.article(id: item.id))
//            .map(models: HomeArticleModel.self)
//            .subscribe(onSuccess: { [weak self] data in
//                self?.menuPageListData[page] = data
//                self?.pageListData.onNext((data, page))
//            }) { error in
//
//        }
//        .disposed(by: disposeBag)
    }
}
