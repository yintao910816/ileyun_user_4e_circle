//
//  HCLocationManager.swift
//  HuChuangApp
//
//  Created by yintao on 2019/8/16.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

class HCLocationManager: NSObject {

    private var locationManager: CLLocationManager!
    
    public let locationSubject = PublishSubject<CLLocation?>()
    
    override init() {
        super.init()
        locationManager = CLLocationManager.init()
        
        reLocationAction()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    private func reLocationAction(){
        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest//定位最佳
        locationManager.distanceFilter = 500.0//更新距离
        locationManager.requestWhenInUseAuthorization()
    }
    
}

extension HCLocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (CLLocationManager.locationServicesEnabled()){
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                if (CLLocationManager.locationServicesEnabled()){
                    locationManager.startUpdatingLocation()
                    print("定位开始")
                }else {
                    locationSubject.onNext(nil)
                }
            default:
                break
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        PrintLog("获取经纬度发生错误:\(error)")
        locationSubject.onNext(nil)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let thelocations:NSArray = locations as NSArray
        let location = thelocations.lastObject as! CLLocation
        locationManager.stopUpdatingLocation()
        
        locationSubject.onNext(location)
    }

}


