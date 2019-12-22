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
    public let exchangeUISubject = PublishSubject<Void>()
    public let commitChangeSubject = PublishSubject<(HCMergeProOpType, String)>()

    /// 怀孕率数据
    private var prepareProbabilityDatas: [Float] = []
    private var prepareTimesDatas: [String] = []
    /// 当前周期数据
    public var currentCircleData: HCRecordItemDataModel?
    /// 三个周期数据
    private var circleDatas: [HCRecordData] = []
    /// 底部操作cell
    private var cellActionItemDatasource: [HCRecordData] = []
    /// 是否是对比的UI
    private var isContrast: Bool = false

    /// 所有cell数据
    public var datasource: [[HCRecordData]] = []
        
    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [unowned self] in
            self.prepareActionData()
            self.requestRecordData()
        })
        .disposed(by: disposeBag)
        
        exchangeUISubject.subscribe(onNext: { [weak self] in
            self?.exchangeData()
        })
        .disposed(by: disposeBag)
        
        commitChangeSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in
            self.commitChange(type: $0.0, data: $0.1)
        })
        .disposed(by: disposeBag)
    }
    
    private func requestRecordData() {
        HCProvider.request(.getLast2This2NextWeekInfo)
            .map(models: HCRecordItemDataModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.dealData(datas: data)
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    

    
    private func prepareActionData() {
        let model1 = HCCellActionItem()
        model1.title = "标记月经"
        model1.itemWidth = 80
        
        let model2 = HCCellActionItem()
        model2.title = "标记排卵日"
        model2.itemWidth = 90

        let model3 = HCCellActionItem()
        model3.title = "标记同房"
        model3.itemWidth = 80

        let model4 = HCCellActionItem()
        model4.title = "基础体温"
        model4.itemWidth = 80

        cellActionItemDatasource = [model1, model2, model3, model4]
    }
}

extension HCRecordViewModel {
    
    private func exchangeData() {
        isContrast = !isContrast
        datasource.removeAll()
        
        if isContrast {
            datasource.append(circleDatas)
        }else {
            if let data = currentCircleData {
                datasource.append([data])
            }
            datasource.append(cellActionItemDatasource)
        }
        
        reloadUISubject.onNext(Void())
    }
    
    private func commitChange(type: HCMergeProOpType, data: String) {
        var dataParam: [String: Any] = [:]
        if type == .temperature {
            dataParam["data"] = ["temperature": data]
        }else {
            dataParam["data"] = data
        }
        
        HCProvider.request(.mergePro(opType: type, data: dataParam))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                if res.code == RequestCode.success.rawValue {
                    self?.requestRecordData()
                }else {
                    self?.hud.failureHidden(res.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }
    
    private func dealData(datas: [HCRecordItemDataModel]) {
        guard datas.count == 3 else { return }

        circleDatas.removeAll()
        currentCircleData = nil
        
        var idx = 0
        for var item in datas {
            if item.cycle > 0 && item.keepDays > 0 && item.menstruationDate.count > 0 {
                formatCircle(data: &item)
                if idx == 1 {
                    currentCircleData = item
                }
                circleDatas.append(item)
            }else {
                PrintLog("非法数据")
            }
            idx += 1
        }

//        for var item in datas {
//            if item.cycle > 0 && item.keepDays > 0 && item.menstruationDate.count > 0 {
//                if item != currentCircleData {
//                    formatCircle(data: &item)
//                }
//                circleDatas.append(item)
//            }else {
//                PrintLog("非法数据")
//            }
//        }
        
        if let c = currentCircleData {
            datasource.append([c])
        }
        
        datasource.append(cellActionItemDatasource)
        
        reloadUISubject.onNext(Void())
        
        hud.noticeHidden()
    }
    
    private func formatCircle(data: inout HCRecordItemDataModel) {
        /// ---月经期推算
        // 第一天
        let starYj = TYDateCalculate.date(for: data.menstruationDate)
        // 最后一天
        let endYj = TYDateCalculate.getDate(currentDate: starYj, days: data.keepDays - 1, isAfter: true)
        let yjArr: [Date] = TYDateCalculate.getDates(startDate: starYj, endDate: endYj)
        PrintLog("starYj: \(starYj) -- endYj: \(endYj) arr: \(yjArr)")

        /// --- 排卵期日期推算
        let circleEndDate = TYDateCalculate.getDate(currentDate: starYj, days: data.cycle - 1, isAfter: true)
        // 排卵日
        let plaDate = TYDateCalculate.getDate(currentDate: circleEndDate, days: 14, isAfter: false)
        // 排卵期第一天 排卵日a往前推5天
        let starPlqDate = TYDateCalculate.getDate(currentDate: plaDate, days: 5, isAfter: false)
        // 排卵期最后一天 排卵日a往后推4天
        let endPlqDate = TYDateCalculate.getDate(currentDate: plaDate, days: 4, isAfter: true)
        let plqArr: [Date] = TYDateCalculate.getDates(startDate: starPlqDate, endDate: endPlqDate)
        
        PrintLog("plq-- circleEndDate: \(circleEndDate) -- plaDate: \(plaDate) starPlqDate: \(starPlqDate) endPlqDate - \(endPlqDate)")
        
        PrintLog("starPlqDate: \(starPlqDate) -- endPlqDate: \(endPlqDate) arr: \(plqArr)")

        /// ---排卵期后安全期日期推算
        // 第一天
        let starSafeAfterDate = TYDateCalculate.getDate(currentDate: endPlqDate, days: 1, isAfter: true)
        let safeAfterArr: [Date] = TYDateCalculate.getDates(startDate: starSafeAfterDate, endDate: circleEndDate)
        PrintLog("starSafeAfterDate: \(starSafeAfterDate) -- circleEndDate: \(circleEndDate) arr: \(safeAfterArr)")

        /// ---排卵期前安全期日期推算
        // 第一天
        let starSafeBefore = TYDateCalculate.getDate(currentDate: endYj, days: 1, isAfter: true)
        // 最后一天
        let endSafeBefore = TYDateCalculate.getDate(currentDate: starPlqDate, days: 1, isAfter: false)
        let safeBeforeArr: [Date] = TYDateCalculate.getDates(startDate: starSafeBefore, endDate: endSafeBefore)
        PrintLog("starSafeBefore: \(starSafeBefore) -- endSafeBefore: \(endSafeBefore) arr: \(safeBeforeArr)")

        var allDates: [Date] = []
        allDates.append(contentsOf: yjArr)
        allDates.append(contentsOf: safeBeforeArr)
        allDates.append(contentsOf: plqArr)
        allDates.append(contentsOf: safeAfterArr)
        
        // 怀孕几率数据
        var probabilityDatas: [Float] = []
        
        // 月经期怀孕几率
        for _ in 0..<yjArr.count {
            probabilityDatas.append(0.01)
        }

        // 排卵期前的安全期怀孕几率
        var beforeSafeProbabilityDatas: [Float] = [0.05,0.06,0.08,0.09,0.11,0.13,0.14]
        if safeBeforeArr.count > 0 {
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
        }
        
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
        
        var yjPoints: [TYPointItemModel] = []
        for date in yjArr {
            let com = TYDateCalculate.getDataComponent(date: date)
            let m = TYPointItemModel(borderColor: .clear, time: "\(com.month!).\(com.day!)")
            yjPoints.append(m)
        }

        var safeBeforePoints: [TYPointItemModel] = []
        for date in safeBeforeArr {
            let com = TYDateCalculate.getDataComponent(date: date)
            let m = TYPointItemModel(borderColor: .clear, time: "\(com.month!).\(com.day!)")
            safeBeforePoints.append(m)
        }

        var plqPoints: [TYPointItemModel] = []
        for date in plqArr {
            let com = TYDateCalculate.getDataComponent(date: date)
            let m = TYPointItemModel(borderColor: .clear, time: "\(com.month!).\(com.day!)")
            plqPoints.append(m)
        }

        var safeAfterPoints: [TYPointItemModel] = []
        for date in safeAfterArr {
            let com = TYDateCalculate.getDataComponent(date: date)
            let m = TYPointItemModel(borderColor: .clear, time: "\(com.month!).\(com.day!)")
            safeAfterPoints.append(m)
        }
        
        if safeBeforeArr.count > 0 {
            data.lineItemDatas = [TYLineItemModel(color: RGB(213, 89, 92),
                                                  percentage: CGFloat(yjArr.count)/CGFloat(data.cycle),
                                                  pointDatas: yjPoints),
                                  TYLineItemModel(color: RGB(84, 197, 141),
                                                  percentage: CGFloat(safeBeforeArr.count)/CGFloat(data.cycle),
                                                  pointDatas: safeBeforePoints),
                                  TYLineItemModel(color: RGB(255, 113, 17),
                                                  percentage: CGFloat(plqArr.count)/CGFloat(data.cycle),
                                                  pointDatas: plqPoints),
                                  TYLineItemModel(color: RGB(84, 197, 141),
                                                  percentage: CGFloat(safeAfterArr.count)/CGFloat(data.cycle),
                                                  pointDatas: safeAfterPoints)]            
        }else {
            data.lineItemDatas = [TYLineItemModel(color: RGB(213, 89, 92),
                                                  percentage: CGFloat(yjArr.count)/CGFloat(data.cycle),
                                                  pointDatas: yjPoints),
                                  TYLineItemModel(color: RGB(255, 113, 17),
                                                  percentage: CGFloat(plqArr.count)/CGFloat(data.cycle),
                                                  pointDatas: plqPoints),
                                  TYLineItemModel(color: RGB(84, 197, 141),
                                                  percentage: CGFloat(safeAfterArr.count)/CGFloat(data.cycle),
                                                  pointDatas: safeAfterPoints)]
        }
                
//        var pointDatas: [TYPointItemModel] = []
//        for _ in 0...resultDates.count {
//            pointDatas.append(TYPointItemModel(borderColor: .clear))
//        }
//
//        data.pointDatas = pointDatas
    }
}

extension HCRecordViewModel {
    
    public func referenceSize(forHeader section: Int) ->CGSize {
        if datasource.count == 1 {
            return .init(width: PPScreenW, height: HCExchangeReusableView_height)
        }else if datasource.count == 2 {
            return section == 0 ? .init(width: PPScreenW, height: HCRecordUserInfoReusableView_height) : .init(width: PPScreenW, height: HCRecordSuggestReusableView_height)
        }
        return .zero
    }
    
    public func inset(_ section: Int) -> UIEdgeInsets {
        if datasource.count == 1 {
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        }else if datasource.count == 2 {
            return section == 0 ? .init(top: 0, left: 0, bottom: 0, right: 0) : .init(top: 0, left: 20, bottom: 0, right: 20)
        }
        return .zero
    }
    
    public func minimumLineSpacing(_ section: Int) ->CGFloat {
        if datasource.count == 1 {
            return 0
        }else if datasource.count == 2 {
            return section == 0 ? 0 : 10
        }
        return 0
    }
    
    public func minimumInteritemSpacing(_ section: Int) ->CGFloat {
        if datasource.count == 1 {
            return 0
        }else if datasource.count == 2 {
            return section == 0 ? 0 : 30
        }
        return 0
    }
    
    public func supplementaryIdentifier(for section: Int) ->String {
        if datasource.count == 1 {
            return HCExchangeReusableView_identifier
        }else if datasource.count == 2 {
            return section == 0 ? HCRecordUserInfoReusableView_identifier : HCRecordSuggestReusableView_identifier
        }
        return ""
    }
}
