//
//  HCSettingViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

import RxSwift
import RxDataSources

class HCUserInfoViewModel: BaseViewModel {
    
    private var cellItems: [SectionModel<Int, HCListCellItem>] = []
    
    public let datasource = Variable([SectionModel<Int, HCListCellItem>]())
    
    override init() {
        super.init()
        
        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [weak self] _ in
                self?.reloadUserInfo()
            })
            .disposed(by: disposeBag)
        
        reloadUserInfo()
    }
    
    private func reloadUserInfo() {
        let userModel = HCHelper.share.userInfoModel ?? HCUserModel()
        cellItems = [SectionModel.init(model: 0, items: [HCListCellItem(title: "昵称",
                                                                        detailTitle: userModel.name,
                                                                        titleColor: RGB(60, 60, 60),
                                                                        detailTitleColor: RGB(173, 173, 173),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: "editNickNameSegue"),
                                                         HCListCellItem(title: "性别",
                                                                        detailTitle: userModel.sexText,
                                                                        titleColor: RGB(60, 60, 60),
                                                                        detailTitleColor: RGB(173, 173, 173),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: "editNickNameSegue"),
                                                         HCListCellItem(title: "出生日期",
                                                                        detailTitle: userModel.birthday,
                                                                        titleColor: RGB(60, 60, 60),
                                                                        detailTitleColor: RGB(173, 173, 173),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: ""),
                                                         HCListCellItem(title: "手机号",
                                                                        detailTitle: userModel.mobileInfo,
                                                                        titleColor: RGB(60, 60, 60),
                                                                        detailTitleColor: RGB(173, 173, 173),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: ""),
                                                         HCListCellItem(title: "地区",
                                                                        detailTitle: "武汉",
                                                                        titleColor: RGB(60, 60, 60),
                                                                        detailTitleColor: RGB(173, 173, 173),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: "")])]
        
        datasource.value = cellItems
    }
    
    /// 获取当前cell的数据源
    public func cellModel(for indexPath: IndexPath) ->HCListCellItem {
        return cellItems[indexPath.section].items[indexPath.row]
    }
}
