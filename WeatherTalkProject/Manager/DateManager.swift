//
//  DateManager.swift
//  WeatherTalkProject
//
//  Created by 최윤제 on 2022/08/13.
//

import Foundation

class DateManager {
    
    static let shared = DateManager()
    
    private init() { }
    
    func nowTime() -> String {
        let format = DateFormatter()
        
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(abbreviation: "KST")
        
        format.dateFormat = "MM월 dd일  hh시 mm분"
        
        let result = format.string(from: Date())
        
        return result
    }
    
    
}
