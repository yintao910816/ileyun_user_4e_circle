//
//  HCFiliter.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/19.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class HCAllCityItemModel: HJModel {
    var key: String = ""
    var list: [HCCityItemModel] = []
}

class HCCityItemModel: HJModel {
    var id: String = ""
    var name: String = ""
}
