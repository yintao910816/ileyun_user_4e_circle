//
//  Home.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import HandyJSON

class HomeBannerModel: HJModel {
    var bak: String = ""
    var beginDate: String = ""
    var code: String = ""
    var content: String = ""
    var createDate: String = ""
    var creates: String = ""
    var del: String = ""
    var endDate: String = ""
    var id: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var path: String = ""
    var sort: String = ""
    var title: String = ""
    var type: String = ""
    var unitId: String = ""
    var link: String = ""

    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &link, name: "url")
    }
}

extension HomeBannerModel: CarouselSource {
    
    var url: String? { return path }
}

class HomeNoticeModel: HJModel {
    
    var bak: String = ""
    var content: String = ""
    var createDate: String = ""
    var creates: String = ""
    var id: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var title: String = ""
    var type: String = ""
    var unitId: String = ""
    var url: String = ""
    var validDate: String = ""
}

extension HomeNoticeModel: ScrollTextModel {
   
    var textContent: String {
        return content
    }
    
    var height: CGFloat { return 45 }
    
}

class HomeGoodNewsModel: HJModel {
    var unitName: String = ""
    var list: [HomeGoodNewsItemModel] = []
}

class HomeGoodNewsItemModel: HJModel {
    var appid: String = ""
    var name: String = ""
    var count: String = ""
    var deliver: String = ""
    var pid: String = ""
    var oid: String = ""
    var type: String = ""
    var mcardno: String = ""
    var rowid: String = ""
}

extension HomeGoodNewsItemModel: ScrollTextModel {
    
    var textContent: String {
        name.first
        if type == "childbirth" {
            return "热烈庆祝\(name)于\(deliver)成功分娩"
        }
        return "未知类型"
    }
    
    var height: CGFloat { return 43 }
}


class HomeFunctionModel: HJModel {
    var bak: String = ""
    var code: String = ""
    var createDate: String = ""
    var creates: String = ""
    var functionUrl: String = ""
    var hide: String = ""
    var iconPath: String = ""
    var id: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var name: String = ""
    var recom: String = ""
    var sort: String = ""
    var type: String = ""
    var unitId: String = ""
    var unitName: String = ""
}

class HomeArticleModel: HJModel {
    var id: String = ""
    var shopId: String = ""
    var title: String = ""
    var info: String = ""
    var author: String = ""
    var picPath: String = ""
    var content: String = ""
    var publishDate: String = ""
    var sort: Int = 0
    var channelId: Int = 0
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
    var seoDescription: String = ""
    var seoKeywords: String = ""
    var code: String = ""
    var unitId: String = ""
    var del: String = ""
    var recom: String = ""
    var top: Bool = false
    var release: Bool = false
    var hrefUrl: String = ""
    var readNumber: String = "0"
    
    lazy var cellHeight: CGFloat = {
        
        var height: CGFloat = 85.0
        var titleH: CGFloat = self.title.getTextHeigh(fontSize: 14,
                                                      width: UIScreen.main.bounds.width - 92,
                                                      fontName: FontName.PingFRegular.rawValue)
        height += (titleH > 20 ? 20 : 0)
        
        var desH: CGFloat = self.title.getTextHeigh(fontSize: 12,
                                                    width: UIScreen.main.bounds.width - 92,
                                                    fontName: FontName.PingFRegular.rawValue)
        height += (desH > 17 ? 17 : 0)
        
        return height
    }()
}

class HomeColumnItemModel: HJModel {
    var id: Int = 0
    var shopId: String = ""
    var parentId: String = ""
    var path: String = ""
    var name: String = ""
    var type: String = ""
    var url: String = ""
    var target: String = ""
    var sort: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
    var code: String = ""
    var unitId: String = ""
    var hide: Bool = false
    var del: Bool = false
    
    var isSelected: Bool = false
    
    lazy var cellSize: CGSize = {
        let width = self.name.getTexWidth(fontSize: 13, height: 20)
        return CGSize.init(width: width, height: 35)
    }()
    
    
}

class HomeColumnModel: HJModel {
    var title: String = ""
    var content: [HomeColumnItemModel] = []
}

class HCAllChannelArticleModel: HJModel {

    var size: Int = 0
    var current: Int = 0
    
    var records: [HCAllChannelArticleItemModel] = []
}

class HCAllChannelArticleItemModel: HJModel {
    var id: Int = 0
    var shopId: Int = 0
    var title: String = ""
    var info: String = ""
    var author: String = ""
    var picPath: String = ""
    var content: String = ""
    var publishDate: String = ""
    var sort: Int = 0
    var channelId: Int = 0
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
    var seoDescription: String = ""
    var seoKeywords: String = ""
    var code: Int = 0
    var unitId: Int = 0
    var linkTypes: Int = 0
    var linkUrls: String = ""
    var readNumber: Int = 0
    var hrefUrl: String = ""
    var store: Int = 0
    var del: Bool = false
    var recom: Bool = false
    var release: Bool = false
    var top: Bool = false
    
    lazy var storeText: String = {
        return "\(self.store) 收藏"
    }()
    
    lazy var readText: String = {
        return "\(self.readNumber) 阅读"
    }()
}
