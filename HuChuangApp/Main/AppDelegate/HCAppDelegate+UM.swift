//
//  HCAppDelegate+UM.swift
//  HuChuangApp
//
//  Created by yintao on 2019/2/26.
//  Copyright © 2019 sw. All rights reserved.
//

private let AppKey = "5d5811164ca357b2690003a2"
private let AppSecret = "wnk8jo4tswwlyy5tkgsalypydl1hk0xh"

import Foundation

extension HCAppDelegate {
   
    func setupUM(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        registerAuthor()
        
        UMConfigure.initWithAppkey(AppKey, channel: "App Store")
        MobClick.setScenarioType(.E_UM_NORMAL)
        UMConfigure.setLogEnabled(true)
        
        UMessage.setAutoAlert(false)
        UMessage.setBadgeClear(true)
        
        if #available(iOS 10.0, *) {
            let entity = UMessageRegisterEntity()
            entity.types = Int(UMessageAuthorizationOptions.badge.rawValue) | Int(UMessageAuthorizationOptions.alert.rawValue)
            //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
     
            // 使用 UNUserNotificationCenter 来管理通知
            let center = UNUserNotificationCenter.current()
            //监听回调事件
            center.delegate = self
            
            UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (flag, error) in
                if flag == true {
                    PrintLog("UM注册成功")
                }else {
                    PrintLog("UM注册失败")
                }
            }
            
            //iOS 10 使用以下方法注册，才能得到授权
            center.requestAuthorization(options: [UNAuthorizationOptions.alert,UNAuthorizationOptions.badge,UNAuthorizationOptions.sound], completionHandler: { (granted:Bool, error:Error?) -> Void in
                if (granted) {
                    //点击允许
//                    PrintLog("注册通知成功")
//                    UserDefaults.standard.set(true, forKey: kReceiveRemoteNote)
                    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
                    center.getNotificationSettings(completionHandler:{(settings:UNNotificationSettings) in
                        PrintLog( "UNNotificationSettings")
                    })
                } else {
                    //点击不允许
//                    UserDefaults.standard.set(false, forKey: kReceiveRemoteNote)
//                    PrintLog("注册通知失败")
                }
            })
        } else {
            // Fallback on earlier versions
            let type = UIUserNotificationType.alert.rawValue | UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue
            let set = UIUserNotificationSettings.init(types: UIUserNotificationType(rawValue: type), categories: nil)
            UIApplication.shared.registerUserNotificationSettings(set)
        }
        
        _ = NotificationCenter.default.rx.notification(NotificationName.User.LoginSuccess, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.uploadUMToken()
            })
    }
}

extension HCAppDelegate : UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        PrintLog("didRegister notificationSetting")
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var deviceTokenString = String()
        let bytes = [UInt8](deviceToken)
        for item in bytes {
            deviceTokenString += String(format:"%02x", item&0x000000FF)
        }
        PrintLog("推送token \(deviceTokenString)")
        
        UMessage.registerDeviceToken(deviceToken)
        
        self.deviceToken = deviceTokenString
        uploadUMToken()
    }
    
    //收到远程推送消息
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UMessage.didReceiveRemoteNotification(userInfo)
        self.receiveRemoteNotificationForbackground(userInfo: userInfo)
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let information = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            UMessage.didReceiveRemoteNotification(information)
            self.receiveRemoteNotificationForbackground(userInfo: information)
        }else{
            //应用处于后台时的本地推送接受
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let information = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            UMessage.didReceiveRemoteNotification(information)
            self.receiveRemoteNotificationForbackground(userInfo: information)
        }else{
            //应用处于前台时的本地推送接受
        }
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
        completionHandler(UNNotificationPresentationOptions.badge)
    }
    
    
    func receiveRemoteNotificationForbackground(userInfo : [AnyHashable : Any]){
        PrintLog(userInfo)
        
        DispatchQueue.main.async {
            HCHelper.pushLocalH5(type: .noticeAndMessage)
        }

//        let message = userInfo["alert"] as? String ?? "alert"
        
//        let tabVC = self.window?.rootViewController as! MainTabBarController
//        let selVC = tabVC.selectedViewController as! UINavigationController
//
//        let alertController = UIAlertController(title: "新消息提醒",
//                                                message: message, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
//        let okAction = UIAlertAction(title: "马上查看", style: .default, handler: {(action)->() in
//            let notificationType = userInfo["notificationType"] as? String  ?? ""
//            switch notificationType {
//            case "21" :
//                HCPrint(message: "21")
//                let url = userInfo["url"] as? String ?? "http://www.ivfcn.com"
//                let webVC = WebViewController()
//                webVC.url = url
//                selVC.pushViewController(webVC, animated: true)
//            case "22" :
//                HCPrint(message: "22")
//                selVC.pushViewController(ConsultRecordViewController(), animated: true)
//            case "23" :
//                HCPrint(message: "23")
//                let survey = userInfo["url"] as! String
//                let webVC = WebViewController()
//                webVC.url = survey
//                selVC.pushViewController(webVC, animated: true)
//            default :
//                HCPrint(message: "default")
//                selVC.pushViewController(MessageViewController(), animated: true)
//            }
//        })
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
        
//        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}

extension HCAppDelegate {
    
    private func uploadUMToken() {
        guard deviceToken.count > 0 else { return }

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { [weak self] (set) in
                guard let strongSelf = self else { return }
                if set.authorizationStatus == UNAuthorizationStatus.notDetermined{
                    PrintLog("推送不允许")
                    strongSelf.isAuthorizedPush = false
                }else if set.authorizationStatus == UNAuthorizationStatus.denied{
                    PrintLog("推送不允许")
                    strongSelf.isAuthorizedPush = false
                }else if set.authorizationStatus == UNAuthorizationStatus.authorized
                {
                    PrintLog("推送允许")
                    strongSelf.isAuthorizedPush = true
                    _ = HCProvider.request(.UMAdd(deviceToken: strongSelf.deviceToken))
                        .mapResponse()
                        .subscribe(onSuccess: { res in
                            if RequestCode(rawValue: res.code) == RequestCode.success {
                                PrintLog("友盟token上传成功")
                            }else {
                                PrintLog(res.message)
                            }
                        }) { error in
                            PrintLog("友盟token上传失败：\(error)")
                    }
                }
            }
            
        } else {
            
            guard let ty = UIApplication.shared.currentUserNotificationSettings?.types else { return }
            if Int(ty.rawValue) == 0{
                PrintLog("用户不允许推送")
                isAuthorizedPush = false
            }else{
                PrintLog("用户允许推送")
                isAuthorizedPush = true
                _ = HCProvider.request(.UMAdd(deviceToken: deviceToken))
                    .mapResponse()
                    .subscribe(onSuccess: { res in
                        if RequestCode(rawValue: res.code) == RequestCode.success {
                            PrintLog("友盟token上传成功")
                        }else {
                            PrintLog(res.message)
                        }
                    }) { error in
                        PrintLog("友盟token上传失败：\(error)")
                }
            }
            
        }
        
    }
}

extension HCAppDelegate: WXApiDelegate {
    
    public func registerAuthor() {
        UMSocialManager.default()?.openLog(true)
        UMSocialManager.default()?.setPlaform(.wechatSession,
                                              appKey: weixinAppid,
                                              appSecret: weixinSecret,
                                              redirectURL: "http://mobile.umeng.com/social")
        
        UMSocialManager.default()?.setPlaform(.wechatTimeLine,
                                              appKey: weixinAppid,
                                              appSecret: weixinSecret,
                                              redirectURL: "http://mobile.umeng.com/social")
    }
    
    func onReq(_ req: BaseReq!) {
        PrintLog("wx onReq \(req)")
    }
    
    func onResp(_ resp: BaseResp!) {
        
    }
}

extension HCAppDelegate {
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
//        let urlString = url.absoluteString
//
//        if urlString.contains("wx") {
//            return WXApi.handleOpen(url, delegate: self)
//        }
                
        let result = UMSocialManager.default()?.handleOpen(url)
        return result!
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.absoluteString.contains(HCHelper.AppKeys.appSchame.rawValue) {
            let param = url.absoluteString.replacingOccurrences(of: "\(HCHelper.AppKeys.appSchame.rawValue)://", with: "")
            NoticesCenter.alert(title: "应用唤起", message: param)
            return true
        }

//        return WXApi.handleOpen(url, delegate: self)
//        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        let result = UMSocialManager.default()?.handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        return result!
    }
}
