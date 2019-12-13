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
    var menstruationDate: String = ""
    var pregnantTypeId: Int = 0
    
    /// 画曲线数据
    public var prepareProbabilityDatas: [Float] = []
}

struct HCCellActionItem: HCRecordData {
    var title: String = ""
    var width: CGFloat = 0
    var height: CGFloat = 30
}

protocol HCRecordData {
    
}
