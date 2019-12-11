//
//  HCRecordViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/19.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCRecordViewModel: BaseViewModel {
    
    public var listDatasource = Variable([HCListCellItem]())
    public let reloadUISubject = PublishSubject<([Float], [String])>()
    /// 怀孕率数据
    private var prepareProbabilityDatas: [Float] = []
    private var prepareTimesDatas: [String] = []
    
    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [unowned self] in
//            self.configData()
            self.requestRecordData()
        })
        .disposed(by: disposeBag)
    }
    
    private func requestRecordData() {
        prepareData()
        
        HCProvider.request(.getLastWeekInfo)
            .mapJSON()
            .subscribe(onSuccess: { data in
                PrintLog(data)
            }) { error in
                PrintLog(error)
        }
        .disposed(by: disposeBag)
    }
    
    private func prepareData() {
        prepareProbabilityDatas = [0.01,0.01,0.01,0.01,0.01,0.01,
                                   0.05,0.06,0.08,0.09,0.11,0.13,0.14,
                                   0.15,0.20,0.25,0.30,0.35,0.32,0.27,0.22,0.18,0.15,
                                   0.14,0.12,0.11,0.09,0.07,0.06,0.05]
        
        for idx in 1...prepareProbabilityDatas.count {
            prepareTimesDatas.append("\(idx)")
        }
        
        reloadUISubject.onNext((prepareProbabilityDatas, prepareTimesDatas))
    }
    
    private func configData() {
        listDatasource.value = [HCListCellItem(title: "月经来了",
                                               titleIcon: "goumaikechen",
                                               shwoArrow: false,
                                               cellIdentifier: HCListSwitchCell_identifier),
                                HCListCellItem(title: "基础体温",
                                               titleIcon: "goumaikechen",
                                               placeholder: "请输入体温",
                                               shwoArrow: false,
                                               cellIdentifier: HCListDetailInputCell_identifier),
                                HCListCellItem(title: "排卵试纸",
                                               titleIcon: "goumaikechen",
                                               detailTitleColor: .red,
                                               detailButtonSize: .init(width: 100, height: 30),
                                               detailButtonTitle: "+添加", shwoArrow: false,
                                               cellIdentifier: HCListDetailButtonCell_identifier),
                                HCListCellItem(title: "FSH",
                                               titleIcon: "goumaikechen",
                                               detailTitleColor: .red,
                                               detailButtonSize: .init(width: 100, height: 30),
                                               detailButtonTitle: "+添加", shwoArrow: false,
                                               cellIdentifier: HCListDetailButtonCell_identifier),
                                HCListCellItem(title: "B超测排",
                                               titleIcon: "goumaikechen",
                                               detailTitleColor: .red,
                                               detailButtonSize: .init(width: 100, height: 30),
                                               detailButtonTitle: "+添加", shwoArrow: false,
                                               cellIdentifier: HCListDetailButtonCell_identifier),
                                HCListCellItem(title: "排卵试纸",
                                               titleIcon: "goumaikechen",
                                               detailTitleColor: .red,
                                               detailButtonSize: .init(width: 100, height: 30),
                                               detailButtonTitle: "+添加", shwoArrow: false,
                                               cellIdentifier: HCListDetailButtonCell_identifier),
                                HCListCellItem(title: "设为排卵日",
                                               titleIcon: "goumaikechen",
                                               shwoArrow: false,
                                               cellIdentifier: HCListSwitchCell_identifier),
                                HCListCellItem(title: "体重",
                                               titleIcon: "goumaikechen",
                                               placeholder: "请输入体重",
                                               shwoArrow: false,
                                               cellIdentifier: HCListDetailInputCell_identifier),
                                HCListCellItem(title: "同房",
                                               titleIcon: "goumaikechen",
                                               detailTitleColor: .red,
                                               detailButtonSize: .init(width: 100, height: 30),
                                               detailButtonTitle: "+添加", shwoArrow: false,
                                               cellIdentifier: HCListDetailButtonCell_identifier),
                                HCListCellItem(title: "吃叶酸",
                                               titleIcon: "goumaikechen",
                                               shwoArrow: false,
                                               cellIdentifier: HCListSwitchCell_identifier),
                                HCListCellItem(title: "白带",
                                               titleIcon: "goumaikechen",
                                               shwoArrow: false,
                                               cellIdentifier: HCListSwitchCell_identifier),
                                HCListCellItem(title: "心情",
                                               titleIcon: "goumaikechen",
                                               placeholder: "",
                                               shwoArrow: false,
                                               cellIdentifier: HCListDetailInputCell_identifier),
                                HCListCellItem(title: "备忘录",
                                               titleIcon: "goumaikechen",
                                               shwoArrow: true,
                                               cellIdentifier: HCBaseListCell_identifier),
                                HCListCellItem(title: "早孕试纸/验孕棒",
                                               titleIcon: "goumaikechen",
                                               detailTitleColor: .red,
                                               detailButtonSize: .init(width: 100, height: 30),
                                               detailButtonTitle: "+添加", shwoArrow: false,
                                               cellIdentifier: HCListDetailButtonCell_identifier),
                                HCListCellItem(title: "我怀孕了",
                                               titleIcon: "goumaikechen",
                                               shwoArrow: false,
                                               cellIdentifier: HCListSwitchCell_identifier),
                                HCListCellItem(title: "症状",
                                               titleIcon: "goumaikechen",
                                               shwoArrow: false,
                                               cellIdentifier: HCBaseListCell_identifier)]
    }
}
