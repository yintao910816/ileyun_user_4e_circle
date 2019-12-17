//
//  HCSearchViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxDataSources

class HCSearchViewController: BaseViewController {

    private var searchBar: TYSearchBar!
    private var searchRecordView: TYSearchRecordView!
    private var slideCtrl: TYSlideMenuController!
    
    private var pageIds: [HCsearchModule] = [.all, .doctor, .article]
    
    private var viewModel: HCSearchViewModel!

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        view.backgroundColor = .white
        
        searchBar = TYSearchBar.init(frame: .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight))
        searchBar.coverButtonEnable = false
        searchBar.searchPlaceholder = "搜索症状/疾病/药品/医生/科室"
        searchBar.rightItemTitle = "取消"
        searchBar.leftItemIcon = "navigationButtonReturnClick"
        searchBar.inputBackGroundColor = RGB(240, 240, 240)
        searchBar.hasBottomLine = true
        view.addSubview(searchBar)
        
        searchBar.leftItemTapBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        
        searchBar.rightItemTapBack = { [weak self] in
            self?.searchRecordView.isHidden = true
            self?.viewModel.requestSearchSubject.onNext(false)
        }

        searchBar.beginSearch = { [weak self] content in
            self?.searchRecordView.isHidden = true
            self?.viewModel.requestSearchSubject.onNext(true)
        }
        
        searchBar.willSearch = { [weak self] in
            self?.searchRecordView.isHidden = false
        }
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
                
        searchRecordView = TYSearchRecordView.init(frame: .init(x: 0, y: searchBar.frame.maxY, width: view.width, height: searchBar.frame.maxY))
        searchRecordView.isHidden = true
        view.addSubview(searchRecordView)
        
        searchRecordView.clearRecordsCallBack = { [weak self] in
            self?.searchBar.reloadInput(content: nil)
            self?.viewModel.clearSearchRecordSubject.onNext(Void())
        }
        searchRecordView.selectedCallBack = { [weak self] in
            self?.searchRecordView.isHidden = true
            self?.searchBar.resignSearchFirstResponder()
            self?.searchBar.reloadInput(content: $0)
            self?.viewModel.selectedSearchRecordSubject.onNext($0)
        }
    }
    
    override func rxBind() {
        viewModel = HCSearchViewModel()
        
        searchBar.textObser
            .bind(to: viewModel.keyWordObser)
            .disposed(by: disposeBag)
        
        viewModel.searchRecordsObser.asDriver()
            .drive(onNext: { [weak self] in
                self?.searchRecordView.recordDatasource = $0
            })
            .disposed(by: disposeBag)
        
        let allCtrl = HCSearchAllViewController()
        allCtrl.pageIdx = 0
        allCtrl.view.backgroundColor = .white
        allCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: false, isAddNoMoreContent: false)
        allCtrl.pushH5CallBack = {
            HCHelper.pushH5(href: $0)
        }
        
        let doctorCtrl = HCSearchRecommendDoctorViewController()
        doctorCtrl.pageIdx = 1
        doctorCtrl.view.backgroundColor = .white
        doctorCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
        doctorCtrl.didSelectedCallBack = {
            HCHelper.pushH5(href: "\(H5Type.doctorHome.getLocalUrl())?userId=\($0.userId)")
        }
        
//        let classCtrl = HCSearchHealthyCourseViewController()
//        classCtrl.pageIdx = 2
//        classCtrl.view.backgroundColor = .white
//        classCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
        //        allCtrl.didSelectedCallBack = {
        //            HCHelper.pushH5(href: $0.hrefUrl)
        //        }
        
        
        let popularScienceCtrl = HCSearchPopularScienceViewController()
        popularScienceCtrl.pageIdx = 2
        popularScienceCtrl.view.backgroundColor = .white
        popularScienceCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
        //        allCtrl.didSelectedCallBack = {
        //            HCHelper.pushH5(href: $0.hrefUrl)
        //        }
        popularScienceCtrl.pushH5CallBack = {
            HCHelper.pushH5(href: $0)
        }

        slideCtrl.menuItems = TYSlideItemModel.creatSimple(for: ["全部", "医生", "文章"])
//        slideCtrl.menuCtrls = [allCtrl, doctorCtrl, classCtrl, popularScienceCtrl]
        slideCtrl.menuCtrls = [allCtrl, doctorCtrl, popularScienceCtrl]
        
        viewModel.pageListData
            .subscribe(onNext: { [weak self] data in
                guard let strongSelf = self, let page = strongSelf.pageIds.lastIndex(of: data.1) else { return }
                strongSelf.slideCtrl.reloadList(listMode: data.0, page: page)
            })
            .disposed(by: disposeBag)
        
        slideCtrl.pageScroll = { [weak self] page in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.requestSearchListSubject.onNext(strongSelf.pageIds[page])
        }

        viewModel.requestSearchListSubject.onNext(.all)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            searchBar.frame = .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + view.safeAreaInsets.top)
            searchBar.safeArea = view.safeAreaInsets
        } else {
            searchBar.frame = .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + 20)
            searchBar.safeArea = .init(top: 20, left: 0, bottom: 0, right: 0)
        }
        
        slideCtrl.view.frame = .init(x: 0, y: searchBar.frame.maxY, width: view.width, height: view.height - searchBar.frame.maxY)
        searchRecordView.frame = .init(x: 0, y: searchBar.frame.maxY, width: view.width, height: view.height - searchBar.frame.maxY)
    }

}
