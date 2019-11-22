//
//  HomeViewModel.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel: BaseViewModel, VMNavigation {
    
    var bannerModelObser = Variable([HomeBannerModel]())
    var articleModels: [HCAllChannelArticleItemModel] = []

    /// 设置右上角消息数量提醒
    var unreadCountObser = Variable(("", CGFloat(0.0)))
    
    let goodnewsDidSelected = PublishSubject<Int>()

    let messageListPublish = PublishSubject<UINavigationController?>()
    let refreshUnreadPublish = PublishSubject<Void>()
    let refreshCollectionView = PublishSubject<Void>()

    private var articleTypeID: String = ""

    override init() {
        super.init()
        hud.noticeLoading()
        
        messageListPublish
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] _ in self.requestH5(type: .notification) }
            .subscribe(onNext: { [unowned self] model in
                self.hud.noticeHidden()
                self.pushH5(model: model)
                }, onError: { error in
                    self.hud.failureHidden(self.errorMessage(error))
            })
            .disposed(by: disposeBag)
        
        goodnewsDidSelected
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] _ in self.requestH5(type: .goodNews) }
            .subscribe(onNext: { [unowned self] model in
                self.hud.noticeHidden()
                self.pushH5(model: model)
            }, onError: { error in
                self.hud.failureHidden(self.errorMessage(error))
            })
            .disposed(by: disposeBag)
                
        refreshUnreadPublish
            .subscribe(onNext: { [unowned self] in
                self.requestUnread()
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NotificationName.User.LoginSuccess)
            .subscribe(onNext: { [weak self] data in
                self?.requestData()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.UserInterface.jsReloadHome)
            .subscribe(onNext: { [weak self] data in
                self?.requestData()
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.requestData()
            })
            .disposed(by: disposeBag)
    }
    
    func requestData() {
        /// 加载未读消息
        requestUnread()
        /// 加载所数据
        
        Observable.combineLatest(requestBanner(),
                                 requestAllChannelArticle()){ ($0, $1) }
            .subscribe(onNext: { [weak self] data in
                self?.hud.noticeHidden()
                self?.bannerModelObser.value = data.0
                self?.articleModels = data.1
                self?.refreshCollectionView.onNext(Void())
                }, onError: { [unowned self] error in
                    self.hud.failureHidden(self.errorMessage(error))
            })
            .disposed(by: disposeBag)

    }
    
    private func pushH5(model: H5InfoModel) {
        guard model.setValue.count > 0 else { return }
        let url = "\(model.setValue)?token=\(userDefault.token)&unitId=\(userDefault.unitId)"
        HomeViewModel.push(BaseWebViewController.self, ["url": url, "title": model.name])
    }
    
    //MARK:
    //MARK: request
    private func requestBanner() ->Observable<[HomeBannerModel]>{
        return HCProvider.request(.selectBanner)
            .map(models: HomeBannerModel.self)
            .asObservable()
            .catchErrorJustReturn([HomeBannerModel]())
    }
    
    private func requestAllChannelArticle() ->Observable<[HCAllChannelArticleItemModel]>{
        return HCProvider.request(.allChannelArticle(articleType: .webCms001, pageNum: 1, pageSize: 10))
            .map(model: HCAllChannelArticleModel.self)
            .map{ $0.records }
            .asObservable()
            .catchErrorJustReturn([HCAllChannelArticleItemModel]())
    }
    
    private func requestH5(type: H5Type) ->Observable<H5InfoModel> {
        return HCProvider.request(.unitSetting(type: type))
            .map(model: H5InfoModel.self)
            .asObservable()
    }
    
    private func requestUnread() {
        HCProvider.request(.messageUnreadCount)
            .mapJSON()
            .subscribe(onSuccess: { [weak self] res in
                if let dic = res as? [String: Any],
                    let count = dic["data"] as? Int,
                    count > 0{
                    let countString = "\(count)"
                    let countWidth = countString.getTexWidth(fontSize: 12, height: 20) + 10
                    self?.unreadCountObser.value = (countString, countWidth)
                }else {
                    self?.unreadCountObser.value = ("", 0)
                }
            }) { error in
                PrintLog(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func increReadingRequest(id: String) {
        HCProvider.request(.increReading(id: id))
            .mapJSON()
            .subscribe(onSuccess: { res in
                PrintLog("阅读量更新：\(res)")
            }) { error in
                PrintLog("阅读量更新失败：\(error)")
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewModel {
    
    private func functionPush(model: HomeFunctionModel, navigationVC: UINavigationController?) {
        if model.functionUrl.count > 0 {
            var url = model.functionUrl
            PrintLog("h5拼接前地址：\(url)")
            if url.contains("photoSeach") == true {
                HomeViewModel.push(HCScanViewController.self, nil)
                return
            }else if url.contains("?") == false {
                url += "?token=\(userDefault.token)&unitId=\(model.unitId)"
            }else {
                url += "&token=\(userDefault.token)&unitId=\(model.unitId)"
            }
            PrintLog("h5拼接后地址：\(url)")
            
            let webVC = BaseWebViewController()
            webVC.title = model.name
            webVC.url   = url
            navigationVC?.pushViewController(webVC, animated: true)
        }else {
//            hud.failureHidden("功能暂不开放")
        }
    }
    
    // 今日知识push
    private func pushH5(url: String, navigationVC: UINavigationController?) {
        guard url.count > 0 else { return }
        
        let webVC = BaseWebViewController()
        webVC.url   = url
        navigationVC?.pushViewController(webVC, animated: true)
    }
}
