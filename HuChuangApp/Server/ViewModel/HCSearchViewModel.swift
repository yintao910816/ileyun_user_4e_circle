//
//  HCSearchViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/3.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class HCSearchViewModel: BaseViewModel {
    
    private let allCtrl = HCSearchAllViewController()
    private let classCtrl = HCSearchHealthyCourseViewController()
    private let doctorCtrl = HCSearchRecommendDoctorViewController()
    private let popularScienceCtrl = HCSearchPopularScienceViewController()

    public var slideDatasource = Variable(([TYSlideItemModel](),[HCSlideItemController]()))
    /// 搜索全部-健康课程
    private var healthyCourseDatas: [HCSearchDoctorCourseModel] = []
    /// 搜索全部-推荐医生
    private var recommendDoctorDatas: [HCDoctorItemModel] = []
    /// 搜索全部-科普文章
    private var popularScienceDatas: [HCPopularScienceModel] = []
    
    override init() {
        super.init()
        
        let slideItems = TYSlideItemModel.creatSimple(for: ["全部", "课程", "医生", "文章"])

        allCtrl.pageIdx = 0
        classCtrl.pageIdx = 1
        doctorCtrl.pageIdx = 2
        popularScienceCtrl.pageIdx = 3

        slideDatasource.value = (slideItems, [allCtrl, classCtrl, doctorCtrl, popularScienceCtrl])
        
        healthyCourseDatas = HCSearchDoctorCourseModel.creatTestDatas()
        recommendDoctorDatas = HCDoctorItemModel.createTestData()
        popularScienceDatas = HCPopularScienceModel.createTestData()
        
        allCtrl.setData(listData: [healthyCourseDatas, recommendDoctorDatas, popularScienceDatas],
                        footerTitles: ["更多课程 >", "更多医生 >", "更多文章 >"])
        
        classCtrl.setData(listData: healthyCourseDatas)
        doctorCtrl.setData(listData: recommendDoctorDatas)
        popularScienceCtrl.setData(listData: popularScienceDatas)
    }
}
