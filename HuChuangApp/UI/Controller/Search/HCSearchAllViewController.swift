//
//  HCSearchAllViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class HCSearchAllViewController: HCSlideItemController {

    private var tableView: UITableView!
        
    private var datasource: [[HCBaseSearchItemModel]] = []
    private var titleDatas: [String] = []
    private var footerTitles: [String] = []
    
    public var pushH5CallBack:((String)->())?

    override func setupUI() {
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = 0.01
        tableView.tableHeaderView = UIView()
        tableView.sectionHeaderHeight = 0.01

        setContentInsetAdjustmentBehaviorNever(contentView: tableView)

        tableView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        
        tableView.register(HCSearchDoctorCell.self, forCellReuseIdentifier: HCSearchDoctorCell_idetifier)
        tableView.register(HCClassRoomListCell.self, forCellReuseIdentifier: HCClassRoomListCell_identifier)
    }
            
    override func reloadData(data: Any?) {
        guard let models = data as? [HCSearchDataModel], let model = models.first else { return }
        datasource.removeAll()
        
        if model.doctor.count > 0 {
            datasource.append(model.doctor)
            titleDatas.append("医生")
        }
        
        if model.course.count > 0 {
            datasource.append(model.course)
            titleDatas.append("课堂")
        }
        
        if model.article.count > 0 {
            datasource.append(model.article)
            titleDatas.append("文章")
        }
        
        tableView.reloadData()
    }

    override func bind<T>(viewModel: RefreshVM<T>, canRefresh: Bool, canLoadMore: Bool, isAddNoMoreContent: Bool) {
        
        tableView.prepare(viewModel, showFooter: canLoadMore, showHeader: canRefresh, isAddNoMoreContent: isAddNoMoreContent)
    }
}

extension HCSearchAllViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
           
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HCSearchHeaderView.init(frame: .init(x: 0, y: 0, width: tableView.width, height: HCSearchHeaderView_small_height))
        header.showLine = section != 0
        header.titleText = titleDatas[section]
        header.clickedMoreCallBack = {
            
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? HCSearchHeaderView_small_height : HCSearchHeaderView_height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = datasource[indexPath.section][indexPath.row]
        if model.isKind(of: HCSearchDoctorItemModel.self) {
            return HCSearchDoctorCell_Height
        }
        return HCClassRoomListCell_height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = datasource[indexPath.section][indexPath.row]
        
        if model.isKind(of: HCSearchDoctorItemModel.self) {
            let cell = (tableView.dequeueReusableCell(withIdentifier: HCSearchDoctorCell_idetifier) as! HCSearchDoctorCell)
            cell.model = model
            return cell
        }

        let cell = (tableView.dequeueReusableCell(withIdentifier: HCClassRoomListCell_identifier) as! HCClassRoomListCell)
        if model.isKind(of: HCSearchArticleItemModel.self) {
            cell.searchArticleModel = (model as! HCSearchArticleItemModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = datasource[indexPath.section][indexPath.row]
        if model.isKind(of: HCSearchDoctorItemModel.self) {
            let url = "\(H5Type.doctorHome.getLocalUrl())?\((model as! HCSearchDoctorItemModel).userId)"
            pushH5CallBack?(url)
        }else if model.isKind(of: HCSearchArticleItemModel.self) {
            pushH5CallBack?((model as! HCSearchArticleItemModel).linkUrls)
        }else if model.isKind(of: HCSearchArticleItemModel.self) {

        }
    }
}
