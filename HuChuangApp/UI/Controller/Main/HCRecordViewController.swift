//
//  HCRecordViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/28.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCRecordViewController: BaseViewController {

//    private var contentView: HCRecorderView!
    
    private var viewModel: HCRecordViewModel!
    
    private var curveView: TYCurveView!
    
    override func setupUI() {
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = true
//        contentView = HCRecorderView.init(frame: view.bounds)
//        view.addSubview(contentView)
        
        curveView = TYCurveView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: TYCurveView.viewHeight))
        curveView.backgroundColor = .lightGray
        view.addSubview(curveView)
    }
    
    override func rxBind() {
        viewModel = HCRecordViewModel()
//        viewModel.listDatasource.asDriver()
//            .drive(onNext: { [weak self] in self?.contentView.reloadData(data: $0) })
//            .disposed(by: disposeBag)
        
        viewModel.reloadUISubject
            .subscribe(onNext: { [weak self] data in
                self?.curveView.setData(probabilityDatas: data.0, titmesDatas: data.1)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        contentView.frame = view.bounds
    }
}
