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
        navSearchBar.leftItemIcon = "navigationButtonReturn"
        navSearchBar.searchPlaceholder = "搜索"
        navSearchBar.tfSearchIcon = "nav_search_gray"
        
        navSearchBar.leftItemTapBack = { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func rxBind() {
        viewModel = HCExpertConsultViewModel()
        
        listMenuView.setData(listData: viewModel.getListMenuData())
    }
}
