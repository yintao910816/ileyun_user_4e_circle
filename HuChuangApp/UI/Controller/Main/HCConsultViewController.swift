//
//  HCConsultViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class HCConsultViewController: BaseViewController {

    @IBOutlet weak var searchBar: TYSearchBar!
    @IBOutlet weak var operationView: UIView!
    @IBOutlet weak var searchBarHeightCns: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var requestionOutlet: UIButton!
    @IBOutlet weak var findDoctorOutlet: UIButton!
    
    var viewModel: ConsultViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        searchBar.searchPlaceholder = "搜索症状/疾病/药品/医生/科室"
        searchBar.tfBgColor = RGB(220, 220, 220, 0.6)
        searchBar.hasBottomLine = true
        
        searchBar.tapInputCallBack = { [unowned self] in
            self.navigationController?.pushViewController(HCSearchViewController(), animated: true)
        }
                
        shadowView.setCornerAndShaow()
            
        tableView.register(UINib.init(nibName: "HCConsultListCell", bundle: Bundle.main),
                           forCellReuseIdentifier: HCConsultListCell_idetifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if searchBarHeightCns.constant == 44 {
            if #available(iOS 11.0, *) {
                searchBarHeightCns.constant += view.safeAreaInsets.top
                searchBar.safeArea = view.safeAreaInsets
            } else {
                searchBarHeightCns.constant += 20
                searchBar.safeArea = .init(top: 20, left: 0, bottom: 0, right: 0)
            }
        }
    }
    override func rxBind() {
        super.rxBind()

        viewModel = ConsultViewModel.init()
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: HCConsultListCell_idetifier, cellType: HCConsultListCell.self)) { _,model,cell  in
                cell.model = model
        }
        .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // 上下拉刷新绑定
        tableView.prepare(viewModel)
        tableView.headerRefreshing()
        
        // 按钮
        requestionOutlet.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.performSegue(withIdentifier: "editInfoForDoctorSegue", sender: nil)
            })
            .disposed(by: disposeBag)
    }
    
}

extension HCConsultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.datasource.value[indexPath.row].cellHeight
    }
}
