//
//  HCSettingViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxDataSources

class HCSettingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HCSettingViewModel!
    
    override func setupUI() {
        view.backgroundColor = RGB(245, 245, 245)
        navigationItem.title = "设置"
        
        tableView.register(HCListDetailIconCell.self, forCellReuseIdentifier: HCListDetailIconCell_identifier)
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)
        tableView.register(HCListSwitchCell.self, forCellReuseIdentifier: HCListSwitchCell_identifier)
        tableView.register(HCListButtonCell.self, forCellReuseIdentifier: HCListButtonCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCSettingViewModel()
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, HCListCellItem>>.init(configureCell: { _,tb,indexPath,model -> HCBaseListCell in
            let cell = (tb.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell)
            cell.model = model
            return cell
        })
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension HCSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellModel(for: indexPath).cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = RGB(245, 245, 245)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellModel = viewModel.cellModel(for: indexPath)
        if cellModel.isLoginOut {
            HCHelper.share.clearUser()
            HCHelper.presentLogin()
        }else {
            if cellModel.segue.count == 0 { return }
            
            performSegue(withIdentifier: cellModel.segue, sender: nil)
        }
    }
}
