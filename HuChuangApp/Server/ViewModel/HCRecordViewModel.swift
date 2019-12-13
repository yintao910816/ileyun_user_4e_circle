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
    
    public let reloadUISubject = PublishSubject<Void>()
    /// 怀孕率数据
    public var prepareProbabilityDatas: [Float] = []
    public var prepareTimesDatas: [String] = []
    /// 当前周期数据
    public var currentCircleData = HCRecordItemDataModel()
    /// 三个周期数据
    public var circleDatas: [HCRecordItemDataModel] = []

    public var cellItemDatasource: [HCCellActionItem] = []
    
    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [unowned self] in
            self.requestRecordData()
        })
        .disposed(by: disposeBag)
    }
    
    private func requestRecordData() {
        prepareData()
        
        HCProvider.request(.getLast2This2NextWeekInfo)
            .map(models: HCRecordItemDataModel.self)
            .subscribe(onSuccess: { [weak self] data in
                guard data.count == 3 else { return }
                self?.dealData(datas: data)
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    
    private func prepareData() {
        cellItemDatasource = [HCCellActionItem(title: "标记月经", width: 80),
                              HCCellActionItem(title: "标记排卵日", width: 90),
                              HCCellActionItem(title: "标记同房", width: 80),
                              HCCellActionItem(title: "基础体温", width: 80)]
        
        prepareProbabilityDatas = [0.01,0.01,0.01,0.01,0.01,0.01,
                                   0.05,0.06,0.08,0.09,0.11,0.13,0.14,
                                   0.15,0.20,0.25,0.30,0.35,0.32,0.27,0.22,0.18,0.15,
                                   0.14,0.12,0.11,0.09,0.07,0.06,0.05]
        
        for idx in 1...prepareProbabilityDatas.count {
            prepareTimesDatas.append("\(idx)")
        }
    }
}

extension HCRecordViewModel {
    
    private func dealData(datas: [HCRecordItemDataModel]) {
        currentCircleData = datas[1]
        circleDatas = datas
        reloadUISubject.onNext(Void())
        
        PrintLog(formatCircle(data: currentCircleData))
    }
    
    private func formatCircle(data: HCRecordItemDataModel) ->[String] {
        /// --- 排卵期日期推算
        // 排卵期第一天
        let starPlqDate = TYDateCalculate.date(for: data.menstruationDate)
        // 排卵期最后一天
        let endPlqDate = TYDateCalculate.getDate(currentDate: starPlqDate, days: data.keepDays - 1, isAfter: true)
        let plqArr: [Date] = TYDateCalculate.getDates(startDate: starPlqDate, endDate: endPlqDate)
        
        /// ---排卵期后安全期日期推算
        // 第一天
        let starSafeAfterDate = TYDateCalculate.getDate(currentDate: endPlqDate, days: 1, isAfter: true)
        // 最后一天 - 定死持续7天
        let endSafeAfterDate = TYDateCalculate.getDate(currentDate: starSafeAfterDate, days: 6, isAfter: true)
        let safeAfterArr: [Date] = TYDateCalculate.getDates(startDate: starSafeAfterDate, endDate: endSafeAfterDate)

        /// ---排卵期前安全期日期推算
        // 最后一天
        let endSafeBefore = TYDateCalculate.getDate(currentDate: starPlqDate, days: 1, isAfter: false)
        // 第一天 - 定死持续7天
        let starSafeBefore = TYDateCalculate.getDate(currentDate: endSafeBefore, days: 6, isAfter: false)
        let safeBeforeArr: [Date] = TYDateCalculate.getDates(startDate: starSafeBefore, endDate: endSafeBefore)

        /// ---月经期推算
        // 安全期固定位排卵期前后7天，月经期根据排卵期和周期计算
        let yjCircle: Int = data.cycle - 14 - data.keepDays
        // 最后一天
        let endYj = TYDateCalculate.getDate(currentDate: starSafeBefore, days: 1, isAfter: false)
        // 第一天
        let starYj = TYDateCalculate.getDate(currentDate: endYj, days: yjCircle - 1, isAfter: false)
        let yjArr: [Date] = TYDateCalculate.getDates(startDate: starYj, endDate: endYj)

        var allDates: [Date] = []
        allDates.append(contentsOf: yjArr)
        allDates.append(contentsOf: safeBeforeArr)
        allDates.append(contentsOf: plqArr)
        allDates.append(contentsOf: safeAfterArr)

        var resultDates: [String] = []
        for date in allDates {
            let com = TYDateCalculate.getDataComponent(date: date)
            resultDates.append("\(com.month!).\(com.day!)")
        }
        
        // 怀孕几率数据
        var probabilityDatas: [Float] = []
        
        for _ in 0..<yjArr.count {
            probabilityDatas.append(0.01)
        }

        probabilityDatas.append(contentsOf: [0.05, 0.06, 0.08, 0.09, 0.11, 0.13, 0.14])

//        for _ in 0..<plqArr.count {
//            probabilityDatas.append(contentsOf: 0.01)
//        }
//        for _ in 0..<yjArr.count {
//            probabilityDatas.append(contentsOf: 0.01)
//        }

        return resultDates
    }
}
