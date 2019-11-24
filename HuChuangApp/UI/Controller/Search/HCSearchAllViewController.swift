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
        
    private var datasource: [[HCDataSourceAdapt]] = []
    private var footerTitles: [String] = []

    override func setupUI() {        
        tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
                
        tableView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        
        tableView.register(UINib.init(nibName: "HCSearchDoctorCourseCell", bundle: Bundle.main),
                           forCellReuseIdentifier: HCSearchDoctorCourseCell_identifier)
        tableView.register(HCConsultListCell.self, forCellReuseIdentifier: HCConsultListCell_idetifier)
        tableView.register(UINib.init(nibName: "HCPopularScienceCell", bundle: Bundle.main),
                           forCellReuseIdentifier: HCPopularScienceCell_identifier)

        tableView.register(HCSearchFooterView.self, forHeaderFooterViewReuseIdentifier: HCSearchFooterView_identifier)
        tableView.register(HCPopularScienceHeaderView.self, forHeaderFooterViewReuseIdentifier: HCPopularScienceHeaderView_identifier)

        tableView.reloadData()
    }
        
    public func setData(listData: [[HCDataSourceAdapt]], footerTitles: [String]) {
        datasource = listData
        self.footerTitles = footerTitles
    }
}

extension HCSearchAllViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
   
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = (tableView.dequeueReusableHeaderFooterView(withIdentifier: HCSearchFooterView_identifier) as! HCSearchFooterView)
        footer.contentText = footerTitles[section]
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let line = UIView()
            line.backgroundColor = RGB(245, 245, 245)
            return line
        }
        
        if section == 2 {
            let header = (tableView.dequeueReusableHeaderFooterView(withIdentifier: HCPopularScienceHeaderView_identifier) as! HCPopularScienceHeaderView)
            header.titleText = "科普文章"
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 { return 8 }
        
        if section == 2 { return HCPopularScienceHeaderView.viewHeight }

        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return datasource[indexPath.section][indexPath.row].viewHeight
        return HCConsultListCell_Height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: HCSearchDoctorCourseCell_identifier) as! HCSearchDoctorCourseCell)
            cell.model = (datasource[0][indexPath.row] as! HCSearchDoctorCourseModel)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: HCConsultListCell_idetifier) as! HCConsultListCell)
            cell.model = (datasource[1][indexPath.row] as! HCDoctorItemModel)
            return cell
        }
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: HCPopularScienceCell_identifier) as! HCPopularScienceCell)
        cell.model = (datasource[2][indexPath.row] as! HCPopularScienceModel)
        return cell
    }
}
