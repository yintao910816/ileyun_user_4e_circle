//
//  HCClassRoomItemController.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/27.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCClassRoomItemController: HCSlideItemController {

    private var tableView: UITableView!
    private var datasource: [HomeArticleModel] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        tableView = UITableView.init()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 0
        tableView.register(UINib.init(nibName: "HCClassRoomListCell", bundle: Bundle.main),
                           forCellReuseIdentifier: HCClassRoomListCell_identifier)

        tableView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    override func reloadData(data: Any?) {
        if let dataModels = data as? [HomeArticleModel] {
            datasource = dataModels
            tableView.reloadData()
        }
    }
}

extension HCClassRoomItemController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return datasource[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: HCClassRoomListCell_identifier) as! HCClassRoomListCell)
        cell.model = datasource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
