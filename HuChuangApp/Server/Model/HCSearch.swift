//
//  HCSearch.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/3.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class HCSearchDoctorCourseModel: HJModel {

    var courseType: String = "女性内分泌健康课程"
    var couseBrief: String = "ask 法律上看到飞机离开房间沙发客来访即可电视剧阿富汗空军乐山大佛看可是大家安抚旅客被打死了"
    var doctorName: String = "陈医师"
    var doctorJob: String = "主任医生"
        
    /// 测试使用
    public class func creatTestDatas() ->[HCSearchDoctorCourseModel] {
        return [HCSearchDoctorCourseModel()]
    }
}

extension HCSearchDoctorCourseModel: HCDataSourceAdapt {
    
    var viewHeight: CGFloat {
        var height: CGFloat = 15 + 20 + 12
        // couseBrief
        height += self.couseBrief.getTextHeigh(fontSize: 12, width: UIScreen.main.bounds.width - 20, fontName: FontName.PingFRegular.rawValue)
        height += (17 + 25 + 15)
        return height
    }
}

class HCPopularScienceModel: HJModel {
    var title: String = "生生世世生生世世"
    var praise: String = "180个赞"
    
    public class func createTestData() ->[HCPopularScienceModel] {
        return [HCPopularScienceModel(), HCPopularScienceModel()]
    }
}

extension HCPopularScienceModel: HCDataSourceAdapt {
    var viewHeight: CGFloat { return 75 }
}
