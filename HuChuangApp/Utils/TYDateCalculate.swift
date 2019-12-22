//
//  TYDateCalculate.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/14.
//  Copyright © 2019 sw. All rights reserved.
//  时间推算

import Foundation

class TYDateCalculate {
    
    /**
     * 根据一个时间推算出前后多少天的日期
     *  currentDate 当前时间
     *  days 前后多少天
     *  isAfter 是否往后推
     */
    class func getDate(currentDate: Date, days: Int, isAfter: Bool) ->Date {
        let oneDay: TimeInterval = TimeInterval((24 * 60 * 60) * days)
        return currentDate.addingTimeInterval(isAfter ? oneDay : -oneDay)
    }
    
    /**
     * 根据根据两个时间点推算出之间的所有时间
     * startDate 开始时间
     * endDate 结束多少天
     */
    class func getDates(startDate: Date, endDate: Date) ->[Date] {
        var star = startDate
        let end = endDate
        
        let calendar = Calendar.init(identifier: .gregorian)
        
        var compontDates: [Date] = []
        var result: ComparisonResult = star.compare(end)
        while result != .orderedDescending {
            var comps = calendar.dateComponents([.year, .month, .day], from: star)
            compontDates.append(star)
            
            // 后一天
            comps.day = comps.day! + 1
            star = calendar.date(from: comps)!
         
            // 对比日期大小
            result = star.compare(end)
        }
        
        return compontDates
    }
    
    /// 获取指定年/月/日 的Int
    class func getDataComponent(date: Date, component: Set<Calendar.Component> = [.month, .day]) ->DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents(component, from: date)
    }

    /**
     * 字符串格式化时间 yyyy-MM-dd
     */
    class func date(for string: String) ->Date {
        let format = DateFormatter()
        format.locale = Locale(identifier: "zh_CN")
        format.setLocalizedDateFormatFromTemplate("H")
        format.dateFormat = "yyyy-MM-dd"
        let date = format.date(from: string)
        return date ?? Date()
    }
    
    /**
     * 计算两个时间之间的差值
     */
    class func numberOfDays(fromDate: Date, toDate: Date) -> Int {
        let calendar = Calendar.init(identifier: .gregorian)
        let comp = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return comp.day ?? 0
    }
    
    class func numberOfDays(toDate: String) -> Int {
        return numberOfDays(fromDate: Date(), toDate: date(for: toDate))
    }
    
    /**
     * 将当前时间格式化成指定格式
     */
    class func formatNowDate() ->Date {
        let dateFormat = DateFormatter.init()
        dateFormat.locale = Locale(identifier: "zh_CN")
        dateFormat.setLocalizedDateFormatFromTemplate("H")
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormat.string(from: Date())

        return dateFormat.date(from: dateString)!
    }
}
