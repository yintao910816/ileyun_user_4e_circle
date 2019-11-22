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

class HCSettingViewModel: BaseViewModel {
    
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
        cellItems = [SectionModel.init(model: 0, items: [HCListCellItem(title: "头像",
                                                                        detailIcon: userModel.headPath,
                                                                        iconType: .userIcon,
                                                                        titleColor: RGB(60, 60, 60),
                                                                        cellHeight: 70,
                                                                        cellIdentifier: HCListDetailIconCell_identifier,
                                                                        segue: "editAvatarSegue"),
                                                         HCListCellItem(title: "昵称",
                                                                        detailTitle: userModel.name,
                                                                        titleColor: RGB(60, 60, 60),
                                                                        detailTitleColor: RGB(173, 173, 173),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: "editNickNameSegue"),
                                                         HCListCellItem(title: "手机号",
                                                                        detailTitle: userModel.mobileInfo,
                                                                        titleColor: RGB(60, 60, 60),
                                                                        detailTitleColor: RGB(173, 173, 173),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: ""),
                                                         HCListCellItem(title: "微信",
                                                                        detailTitle: "微信号",
                                                                        titleColor: RGB(60, 60, 60),
                                                                        detailTitleColor: RGB(173, 173, 173),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: "")]),
                     SectionModel.init(model: 1, items: [HCListCellItem(title: "推送消息设置",
                                                                        titleColor: RGB(60, 60, 60),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: ""),
                                                         HCListCellItem(title: "自动草稿",
                                                                        titleColor: RGB(60, 60, 60),
                                                                        cellIdentifier: HCListSwitchCell_identifier,
                                                                        segue: "")]),
                     SectionModel.init(model: 1, items: [HCListCellItem(title: "去好评",
                                                                        titleColor: RGB(60, 60, 60),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: ""),
                                                         HCListCellItem(title: "推荐给好友",
                                                                        titleColor: RGB(60, 60, 60),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: ""),
                                                         HCListCellItem(title: "关于我们",
                                                                        titleColor: RGB(60, 60, 60),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: "")]),
                     SectionModel.init(model: 1, items: [HCListCellItem(title: "退出登录",
                                                                        titleColor: RGB(255, 102, 149),
                                                                        cellIdentifier: HCListButtonCell_identifier,
                                                                        isLoginOut: true)])]
        
        datasource.value = cellItems
    }
    
    /// 获取当前cell的数据源
    public func cellModel(for indexPath: IndexPath) ->HCListCellItem {
        return cellItems[indexPath.section].items[indexPath.row]
    }
}
