//
//  HCHealthyCourseViewController.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/3.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCSearchHealthyCourseViewController: HCSlideItemController {

    private var tableView: UITableView!
        
    private var datasource: [HCSearchDoctorCourseModel] = []

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

        tableView.register(HCSearchFooterView.self, forHeaderFooterViewReuseIdentifier: HCSearchFooterView_identifier)

        tableView.reloadData()
    }

    public func setData(listData: [HCSearchDoctorCourseModel]) {
        datasource = listData
    }
}

extension HCSearchHealthyCourseViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
       
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = (tableView.dequeueReusableHeaderFooterView(withIdentifier: HCSearchFooterView_identifier) as! HCSearchFooterView)
        footer.contentText = "更多课程 >"
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 52
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return datasource[indexPath.row].viewHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: HCSearchDoctorCourseCell_identifier) as! HCSearchDoctorCourseCell)
        cell.model = datasource[indexPath.row]
        return cell
    }
}
