//
//  HCMenstruationHistoryViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/26.
//  Copyright © 2019 sw. All rights reserved.
//  月经史

import UIKit

class HCMenstruationHistoryViewController: BaseViewController {

    private var dataModel: HCHealthArchivesModel!
    
    override func setupUI() {
        
    }
    
    override func rxBind() {
        
    }
    
    override func prepare(parameters: [String : Any]?) {
        dataModel = (parameters!["data"] as! HCHealthArchivesModel)
    }
}
