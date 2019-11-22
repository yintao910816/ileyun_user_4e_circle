//
//  HCMineViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxDataSources

class HCMineViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private var header: MineHeaderView!
    
    private var viewModel: MineViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        view.backgroundColor = .white
        
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        header =  MineHeaderView.init(frame: .init(x: 0, y: 0, width: tableView.width, height: 250 + LayoutSize.topVirtualArea))
        tableView.tableHeaderView = header
                
        tableView.rowHeight = 50
        tableView.register(HCMineCell.self, forCellReuseIdentifier: HCMineCell_identifier)
    }
    
    override func rxBind() {
        viewModel = MineViewModel()
        
        header.gotoEditUserInfo
            .bind(to: viewModel.gotoEditUserInfo)
            .disposed(by: disposeBag)
        
        viewModel.userInfo
            .bind(to: header.userModel)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MenuListItemModel.self)
            .bind(to: viewModel.cellDidSelectedSubject)
            .disposed(by: disposeBag)
        
        header.openH5Publish
            .map{ MenuListItemModel.createModel(title: "", h5Type: $0) }
            .bind(to: viewModel.pushH5Subject)
            .disposed(by: disposeBag)

        header.gotoSetting
            .subscribe(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "HCSettingSegue", sender: nil)
            })
            .disposed(by: disposeBag)

        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, MenuListItemModel>>.init(configureCell: { _,tb,indexPath,model ->UITableViewCell in
            let cell = (tb.dequeueReusableCell(withIdentifier: HCMineCell_identifier) as! HCMineCell)
            cell.model = model
            return cell
        })
        
        viewModel.datasource
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
                
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}

extension HCMineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sepView = UIView()
        sepView.backgroundColor = RGB(245, 245, 245)
        return sepView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
}
