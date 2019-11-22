//
//  TYSearchRecordData.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/9.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class TYSearchRecordModel {
    
    public var keyWord: String = ""
    
    public var contentSize: CGSize {
        get {
            let w = keyWord.getTexWidth(fontSize: 12, height: 25, fontName: FontName.PingFMedium.rawValue) + 20
            return .init(width: w, height: 25)
        }
    }
}

class TYSearchSectionModel {
    
    public var sectionTitle: String = ""
    public var showDelete: Bool = false

    public var recordDatas: [TYSearchRecordModel] = []
    
    class func createTest() ->[TYSearchSectionModel] {
        var sectionDatas: [TYSearchSectionModel] = []
        for section in 0..<2 {
            var rowDatas: [TYSearchRecordModel] = []
            for _ in 0..<10 {
                let model = TYSearchRecordModel()
                model.keyWord = "搜索记录"
                rowDatas.append(model)
            }

            let sectionModel = TYSearchSectionModel()
            sectionModel.recordDatas = rowDatas
            sectionModel.showDelete = section == 0
            sectionModel.sectionTitle = "表头"
            sectionDatas.append(sectionModel)
        }
        
        return sectionDatas
    }
}
