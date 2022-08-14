//
//  LocationAPIManager.swift
//  WeatherTalkProject
//
//  Created by 최윤제 on 2022/08/14.
//

import Foundation

import Alamofire
import SwiftyJSON
import CoreLocation

struct LocationAPIManager {
    
    static let shared = LocationAPIManager()
    
    private init() { }
    
    typealias completionHandler = (WeatherInfo) -> ()

    func requestLocation(coordinate: CLLocationCoordinate2D, completionHandler: @escaping completionHandler) {
        let lon = coordinate.longitude
        let lat = coordinate.latitude
        
        let url = "\(EndPoint.endPoint)lat=\(lat)&lon=\(lon)&appid=\(APIKey.key)"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var temp = json["main"]["temp"].doubleValue - 273.15
                
                let humidity = json["main"]["humidity"].intValue
                let windSpeed = json["wind"]["speed"].doubleValue
                let imageIcon = json["weather"][0]["icon"].stringValue
                
                temp = round(temp * 10) / 10
                
                let result = WeatherInfo(temp: temp, humidity: humidity, windSpeed: windSpeed, imageIcon: imageIcon)
                
                completionHandler(result)
                
                print(result)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
