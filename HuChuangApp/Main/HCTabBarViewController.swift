//
//  HCTabBarViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCTabBarViewController: UITabBarController {

    private var lastSelectedIndex: Int = NSNotFound
    
    private let disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension HCTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if selectedIndex == 1 {
//            if lastSelectedIndex != 1
//            {
//                lastSelectedIndex = 1
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                    self.lastSelectedIndex = NSNotFound
//                }
//            }else if lastSelectedIndex == 1
//            {
//                NotificationCenter.default.post(name: NotificationName.UserInterface.tabBarSelectedTwice, object: true)
//                lastSelectedIndex = NSNotFound
//            }
//        }else
//        {
//            lastSelectedIndex = selectedIndex
//        }
    }
}
