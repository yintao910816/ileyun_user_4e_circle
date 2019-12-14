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
        guard datas.count == 3 else { return }

        currentCircleData = datas[1]
        formatCircle(data: &currentCircleData)

        for var item in datas {
            if item.cycle > 0 && item.keepDays > 0 && item.menstruationDate.count > 0 {
                if item != currentCircleData {
                    formatCircle(data: &item)
                }
                circleDatas.append(item)
            }else {
                PrintLog("非法数据")
            }
        }
        
        reloadUISubject.onNext(Void())
    }
    
    private func formatCircle(data: inout HCRecordItemDataModel) {
        /// ---月经期推算
        // 第一天
        let starYj = TYDateCalculate.date(for: data.menstruationDate)
        // 最后一天
        let endYj = TYDateCalculate.getDate(currentDate: starYj, days: data.keepDays - 1, isAfter: true)
        let yjArr: [Date] = TYDateCalculate.getDates(startDate: starYj, endDate: endYj)

        /// --- 排卵期日期推算
        let circleEndDate = TYDateCalculate.getDate(currentDate: starYj, days: data.cycle - 1, isAfter: true)
        // 排卵日
        let plaDate = TYDateCalculate.getDate(currentDate: circleEndDate, days: 14, isAfter: false)
        // 排卵期第一天 排卵日a往前推5天
        let starPlqDate = TYDateCalculate.getDate(currentDate: plaDate, days: 5, isAfter: false)
        // 排卵期最后一天 排卵日a往后推4天
        let endPlqDate = TYDateCalculate.getDate(currentDate: plaDate, days: 4, isAfter: true)
        let plqArr: [Date] = TYDateCalculate.getDates(startDate: starPlqDate, endDate: endPlqDate)
        
        /// ---排卵期后安全期日期推算
        // 第一天
        let starSafeAfterDate = TYDateCalculate.getDate(currentDate: endPlqDate, days: 1, isAfter: true)
        let safeAfterArr: [Date] = TYDateCalculate.getDates(startDate: starSafeAfterDate, endDate: circleEndDate)

        /// ---排卵期前安全期日期推算
        // 第一天
        let starSafeBefore = TYDateCalculate.getDate(currentDate: endYj, days: 1, isAfter: true)
        // 最后一天
        let endSafeBefore = TYDateCalculate.getDate(currentDate: starPlqDate, days: 1, isAfter: false)
        let safeBeforeArr: [Date] = TYDateCalculate.getDates(startDate: starSafeBefore, endDate: endSafeBefore)

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
        
        // 月经期a怀孕几率
        for _ in 0..<yjArr.count {
            probabilityDatas.append(0.01)
        }

        // 排卵期前的安全期怀孕几率
        var beforeSafeProbabilityDatas: [Float] = [0.05,0.06,0.08,0.09,0.11,0.13,0.14]
        if beforeSafeProbabilityDatas.count >= safeBeforeArr.count {
            let star: Int = beforeSafeProbabilityDatas.count - safeBeforeArr.count
            beforeSafeProbabilityDatas = Array(beforeSafeProbabilityDatas[star..<beforeSafeProbabilityDatas.count])
        }else {
            let count = safeBeforeArr.count - beforeSafeProbabilityDatas.count
            var starPro: Float = 0.14
            for i in 0..<count {
                starPro += (Float(i) * 0.01)
                beforeSafeProbabilityDatas.append(starPro)
            }
        }
        probabilityDatas.append(contentsOf: beforeSafeProbabilityDatas)
        
        // 排卵期怀孕几率
        probabilityDatas.append(contentsOf: [0.15,0.20,0.25,0.30,0.35,0.32,0.27,0.22,0.18,0.15])

        // 排卵期后的安全期怀孕几率
        var afterSafeProbabilityDatas: [Float] = [0.14,0.12,0.11,0.09,0.07,0.06,0.05]
        if afterSafeProbabilityDatas.count >= safeAfterArr.count {
            afterSafeProbabilityDatas = Array(afterSafeProbabilityDatas[0..<safeAfterArr.count])
        }else {
            let count = safeAfterArr.count - afterSafeProbabilityDatas.count
            var starPro: Float = 0.05
            for _ in 0..<count {
                starPro -= 0.01
                starPro = max(0, starPro)
                afterSafeProbabilityDatas.append(starPro)
            }
        }
        probabilityDatas.append(contentsOf: afterSafeProbabilityDatas)

        
        data.probabilityDatas = probabilityDatas
        data.timeDatas = resultDates
    }
}
