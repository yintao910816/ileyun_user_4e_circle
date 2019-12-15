//
//  HCAccountManager.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/16.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class HCAccountManager {
        
    /// 微信授权登录
    class func WeChatLogin() {
        UMSocialManager.default()?.getUserInfo(with: .wechatSession, currentViewController: nil, completion: { (result, error) in
            if error != nil {
                PrintLog("友盟微信登录失败：\(error)")
            }else {
                guard let resp = result as? UMSocialUserInfoResponse else {
                    PrintLog("授权回调结果出错")
                    return
                }
                
                PrintLog("Wechat accessToken: \(resp.accessToken) \n Wechat openid: \(resp.openid)")
            }
        })
    }
}
