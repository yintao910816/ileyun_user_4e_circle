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
        searchBar.leftItemIcon = "navigationButtonReturn"
        searchBar.inputBackGroundColor = RGB(240, 240, 240)
        searchBar.hasBottomLine = true
        view.addSubview(searchBar)
        
        searchBar.leftItemTapBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        
        searchBar.rightItemTapBack = { [weak self] in
            self?.searchRecordView.isHidden = false
        }
        
        searchBar.beginSearch = { [weak self] content in
            self?.searchRecordView.isHidden = true
        }
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        slideCtrl.pageScroll = { [weak self] page in

        }
        
        searchRecordView = TYSearchRecordView.init(frame: .init(x: 0, y: searchBar.frame.maxY, width: view.width, height: searchBar.frame.maxY))
        searchRecordView.recordDatasource = TYSearchSectionModel.createTest()
        view.addSubview(searchRecordView)
    }
    
    override func rxBind() {
        viewModel = HCSearchViewModel()
        
        viewModel.slideDatasource.asDriver()
            .drive(onNext: { [weak self] data in
                self?.slideCtrl.menuItems = data.0
                self?.slideCtrl.menuCtrls = data.1
            })
            .disposed(by: disposeBag)        
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
