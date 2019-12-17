//
//  HCExpertConsultViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/28.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCExpertConsultViewController: BaseViewController {

    @IBOutlet weak var navSearchBar: TYSearchBar!
    @IBOutlet weak var listMenuView: TYListMenuView!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HCExpertConsultViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        navSearchBar.tfBgColor = RGB(247, 247, 247)
        navSearchBar.leftItemIcon = "navigationButtonReturnClick"
        navSearchBar.searchPlaceholder = "搜索"
        navSearchBar.tfSearchIcon = "nav_search_gray"
        
        navSearchBar.leftItemTapBack = { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
        
        tableView.rowHeight = HCConsultListCell_Height
        tableView.register(HCConsultListCell.self, forCellReuseIdentifier: HCConsultListCell_idetifier)
    }
    
    override func rxBind() {
        viewModel = HCExpertConsultViewModel()
        listMenuView.setData(listData: viewModel.getListMenuData())
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: HCConsultListCell_idetifier, cellType: HCConsultListCell.self)) { _,model,cell  in
                cell.model = model
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HCDoctorItemModel.self)
            .subscribe(onNext: {
                HCHelper.pushH5(href: "\(H5Type.doctorHome.getLocalUrl())?userId=\($0.userId)")
            })
            .disposed(by: disposeBag)

        // 上下拉刷新绑定
        tableView.prepare(viewModel, showFooter: false)
        tableView.headerRefreshing()
    }
}
