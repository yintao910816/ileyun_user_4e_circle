//
//  HCRecordViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/28.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCRecordViewController: BaseViewController {

    private var contentView: HCRecorderView!
    
    private var viewModel: HCRecordViewModel!
    
    override func setupUI() {
//        self.edgesForExtendedLayout = UIRectEdgeNone; // view向四周延伸
//        self.navigationController.navigationBar.translucent = NO; // bar不透明
//        self.extendedLayoutIncludesOpaqueBars = NO; // 在不透明情况下允许view向四周延伸

        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = true
        
        contentView = HCRecorderView.init(frame: view.bounds)
        view.addSubview(contentView)
    }
    
    override func rxBind() {
        viewModel = HCRecordViewModel()
        viewModel.listDatasource.asDriver()
            .drive(onNext: { [weak self] in self?.contentView.reloadData(data: $0) })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.frame = view.bounds
    }
}
