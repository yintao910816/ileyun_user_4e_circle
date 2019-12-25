//
//  HCClassRoomViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/28.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCClassRoomViewModel: RefreshVM<HCArticleItemModel> {
    
    private var columnData: HomeColumnModel!
    private var menuPageListData: [Int: [HCArticleItemModel]] = [:]
    // 记录当前第几页数据
    private var page: Int = 0
    
    public let requestTodayListSubject = PublishSubject<Int>()
    
    public let menuItemData = PublishSubject<[TYSlideItemModel]>()
    public let pageListData = PublishSubject<([HCArticleItemModel], Int)>()

    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [unowned self] in self.requestColumnData() })
            .disposed(by: disposeBag)
        
        requestTodayListSubject
            .subscribe(onNext: { [unowned self] page in
                self.page = page
                
                if let list = self.menuPageListData[page] {
                    self.pageListData.onNext((list, page))
                }else {
                    self.requestData(true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        
        updatePage(for: "\(page)", refresh: refresh)
        
        let item = columnData.content[page]
        var signal = HCProvider.request(.articlePage(id: item.id, pageNum: currentPage(for: "\(page)"), pageSize: pageSize(for: "\(page)")))
            .map(model: HCArticlePageDataModel.self)
        
        if page == 0 {
            signal = HCProvider.request(.allChannelArticle(cmsType: .webCms001, pageNum: currentPage(for: "\(page)"), pageSize: pageSize(for: "\(page)")))
                .map(model: HCArticlePageDataModel.self)
        }
        
        signal.subscribe(onSuccess: { [weak self] data in
            guard let strongSelf = self else { return }
            if strongSelf.menuPageListData[strongSelf.page] == nil {
                strongSelf.menuPageListData[strongSelf.page] = [HCArticleItemModel]()
            }
            strongSelf.updateRefresh(refresh: refresh, models: data.records, dataModels: &(strongSelf.menuPageListData[strongSelf.page])!, pages: data.pages, pageKey: "\(strongSelf.page)")
            self?.pageListData.onNext((strongSelf.menuPageListData[strongSelf.page]!, strongSelf.page))
        }) { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.revertCurrentPageAndRefreshStatus(pageKey: "\(strongSelf.page)")
        }
        .disposed(by: disposeBag)

    }
    
    /// 滚动菜单
    private func requestColumnData() {
        HCProvider.request(.column(cmsType: .webCms001))
            .map(model: HomeColumnModel.self)
            .subscribe(onSuccess: { [weak self] model in
                model.content.insert(HomeColumnItemModel.creatAllColum(), at: 0)
                self?.columnData = model
                                
                if model.content.count > 0 {
                    self?.menuItemData.onNext(TYSlideItemModel.mapData(models: model.content))
                    self?.requestData(true)
                }
            }) { error in
                
        }
        .disposed(by: disposeBag)
    }
}
