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
    var functionModelsObser = Variable([HomeFunctionModel]())
    var noticeModelObser = Variable([HomeNoticeModel]())
    var goodNewsModelObser = Variable(HomeGoodNewsModel())
    var columnModelObser   = Variable(HomeColumnModel())
    
    /// 孕柚课堂 数据
    var pregnancyClassroomData: [HCHomePregnancyClassroomMenuModel] = []
    
    /// 根据是否有数据更新header高度
    var headerDataCountObser = Variable((0, 0, 0, false))
    /// 设置右上角消息数量提醒
    var unreadCountObser = Variable(("", CGFloat(0.0)))
    
    var didSelectItemSubject = PublishSubject<HomeColumnItemModel>()
    let noticeDidSelected = PublishSubject<Int>()
    let goodnewsDidSelected = PublishSubject<Int>()
    let todaySelected = PublishSubject<(HomeArticleModel, UINavigationController?)>()

    let functionItemDidSelected = PublishSubject<(HomeFunctionModel, UINavigationController?)>()
    let messageListPublish = PublishSubject<UINavigationController?>()
    let refreshUnreadPublish = PublishSubject<Void>()

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

        todaySelected
            .subscribe(onNext: { [unowned self] data in
                self.increReadingRequest(id: data.0.id)
                self.pushH5(url: data.0.hrefUrl, navigationVC: data.1)
                }, onError: { error in
                    self.hud.failureHidden(self.errorMessage(error))
            })
            .disposed(by: disposeBag)

        functionItemDidSelected.subscribe(onNext: { [unowned self] data in
            self.functionPush(model: data.0, navigationVC: data.1)
        })
            .disposed(by: disposeBag)
        
//        didSelectItemSubject
//            .subscribe(onNext: { [weak self] model in
//                self?.setOffset(refresh: true)
//                self?.articleTypeID = model.id
//                self?.requestArticleData()
//            })
//            .disposed(by: disposeBag)
        
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
        
        noticeDidSelected
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] _ in self.requestH5(type: .announce) }
            .subscribe(onNext: { mdoel in
                self.hud.noticeHidden()
                self.pushH5(model: mdoel)
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
        requestHeaderData()
            .subscribe(onNext: { [weak self] data in
                self?.hud.noticeHidden()
                self?.pregnancyClassroomData = HCHomePregnancyClassroomMenuModel.creatTestData()
                self?.bannerModelObser.value = data.0
                self?.functionModelsObser.value = data.1
                }, onError: { [unowned self] error in
                    self.hud.failureHidden(self.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    private func requestHeaderData() ->Observable<([HomeBannerModel], [HomeFunctionModel], HomeColumnModel)> {
//    private func requestHeaderData() ->Observable<([HomeBannerModel], [HomeFunctionModel], [HomeNoticeModel], HomeColumnModel, HomeGoodNewsModel)> {
//        return Observable.combineLatest(requestBanner(),
//                                        requestFunctionList(),
//                                        requestNoticeList(),
//                                        requestColumData(),
//                                        requestGoodNew()){ ($0, $1, $2, $3, $4) }
//            .asObservable()
        
        return Observable.combineLatest(requestBanner(),
                                        requestFunctionList(),
                                        requestColumData()){ ($0, $1, $2) }
            .asObservable()
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
    
    private func requestFunctionList() ->Observable<[HomeFunctionModel]>{
        return HCProvider.request(.functionList)
            .map(models: HomeFunctionModel.self)
            .asObservable()
            .catchErrorJustReturn([HomeFunctionModel]())
    }
    
    private func requestNoticeList() ->Observable<[HomeNoticeModel]> {
        return HCProvider.request(.noticeList(type: "new", pageNum: 1, pageSize: 10))
            .map(models: HomeNoticeModel.self)
            .asObservable()
            .catchErrorJustReturn([HomeNoticeModel]())
    }
    
    private func requestGoodNew() ->Observable<HomeGoodNewsModel> {
        return HCProvider.request(.goodNews)
            .map(model: HomeGoodNewsModel.self)
            .asObservable()
            .catchErrorJustReturn(HomeGoodNewsModel())
    }
    
    private func requestColumData() ->Observable<HomeColumnModel>{
        return HCProvider.request(.column(cmsCode: "aa"))
        .map(model: HomeColumnModel.self)
        .asObservable()
    }
    
//    private func requestArticleData(){
//        HCProvider.request(.article(id: articleTypeID))
//            .map(models: HomeArticleModel.self)
//            .subscribe(onSuccess: { [weak self] data in
//                self?.updateRefresh(true, data, nil)
//            }) { error in
//                
//            }
//            .disposed(by: disposeBag)
//    }
    
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
    
    private func dealHomeHeaderData(data: ([HomeBannerModel], [HomeFunctionModel], [HomeNoticeModel], HomeColumnModel, HomeGoodNewsModel)) {
        headerDataCountObser.value = (data.1.count, data.2.count, data.4.list.count, data.3.content.count > 0)

        bannerModelObser.value = data.0
        functionModelsObser.value = data.1
        noticeModelObser.value = data.2

        let firstColumModel = data.3.content.first
        firstColumModel?.isSelected = true
        articleTypeID = firstColumModel?.id ?? ""
        columnModelObser.value = data.3
//        requestData(true)
        
        goodNewsModelObser.value = data.4
        
        if let comData = data.3.content.first {
           didSelectItemSubject.onNext(comData)
        }
    }
    
}
