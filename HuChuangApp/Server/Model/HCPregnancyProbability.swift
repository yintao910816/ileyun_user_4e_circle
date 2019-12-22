//
//  HCPregnancyProbability.swift
//  HuChuangApp
//
//  Created by sw on 2019/12/9.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class HCPregnancyProbabilityModel: HJModel {
    /// 今日 —怀孕几率（%）
    var todayProbability: Float = 0
    /// 明日 —怀孕几率（%）
    var tomorrowProbability: Float = 0
    /// 排卵日
    var ovulationDate: String = ""
    /// 提示
    var tips: String = ""
}

/// 记录数据
class HCRecordItemDataModel: HJModel, HCRecordData {
    var cycle: Int = 0
    var id: Int = 0
    var keepDays: Int = 0
    /// 月经起始日期
    var menstruationDate: String = ""
    var pregnantTypeId: Int = 0
    
    /// 计算出的相关周期数据
    // 所处阶段
    var newLv: NSAttributedString = NSAttributedString.init()
    // 怀孕几率
    var probability: NSAttributedString = NSAttributedString.init()
    // 距离排卵日
    var pailuan: NSAttributedString = NSAttributedString.init()
    // 所处哪个周期
    var nowCircle: String = ""
    var curelTitle: String = "好孕率趋势图"
    // 是否是对比数据
    var isContrast: Bool = false
    
    /// 画曲线数据
    public var probabilityDatas: [Float] = []
//    /// 坐标时间 月.日
//    public var timeDatas: [String] = []
    /// 画线数据 - 线条颜色
    public var lineItemDatas: [TYLineItemModel] = []
//    /// 画线数据 - 画点
//    public var pointDatas: [TYPointItemModel] = []

    var cellIdentifier: String { return HCCurveCell_identifier }
    var width: CGFloat { return PPScreenW }
    var height: CGFloat { return HCCurveCell_height }
}

class HCCellActionItem: HCRecordData {
    var title: String = ""
    var opType: HCMergeProOpType = .knewRecord
    var itemWidth: CGFloat = 0
    
    var cellIdentifier: String { return HCRecordActionItemCell_identifier }
    var width: CGFloat { return itemWidth }
    var height: CGFloat { return 30 }
}

protocol HCRecordData {
    var width: CGFloat { get }
    var height: CGFloat { get }
    var cellIdentifier: String { get }
}
