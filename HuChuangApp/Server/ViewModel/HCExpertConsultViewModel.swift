//
//  HCExpertConsultViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/29.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class HCExpertConsultViewModel: BaseViewModel {
    
    private var listMenuData: [TYListMenuModel] = []
    
    override init() {
        super.init()
        
        let listDataTitle = ["全国", "咨询人数", "价格", "筛选"]
        for idx in 0..<listDataTitle.count {
            let model = TYListMenuModel()
            model.title = listDataTitle[idx]
            model.isSelected = idx == 0
            if idx == 0 || idx == 2{
                model.titleIconNormalImage = UIImage.init(named: "btn_gray_down_arrow")
                model.titleIconSelectedImage = UIImage.init(named: "btn_red_down_arrow")
            }else if idx == 3 {
                model.titleIconCanRotate = false
                model.titleIconNormalImage = UIImage.init(named: "list_menu_filiter")
                model.titleIconSelectedImage = UIImage.init(named: "list_menu_filiter")
            }
            
            listMenuData.append(model)
        }
    }
    
    public func getListMenuData() ->[TYListMenuModel] {
        return listMenuData
    }
}
