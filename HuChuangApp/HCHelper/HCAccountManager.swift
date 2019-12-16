//
//  HCAccountManager.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/16.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCAccountManager {
        
    class func WeChatLogin() ->Observable<UMSocialUserInfoResponse?> {
        return Observable<UMSocialUserInfoResponse?>.create { obser -> Disposable in
            UMSocialManager.default()?.getUserInfo(with: .wechatSession, currentViewController: nil, completion: { (result, error) in
                if error != nil {
                    obser.onError(error!)
                }else {
                    obser.onNext(result as? UMSocialUserInfoResponse)
                }
                obser.onCompleted()
            })
            
            return Disposables.create { }
        }
    }
}
