//
//  GeocoderManager.swift
//  WeatherTalkProject
//
//  Created by 최윤제 on 2022/08/14.
//

import Foundation

import CoreLocation

struct GeoCoderManager {
    
    static let shared = GeoCoderManager()
    
    private init() { }
    
    func changeGeo(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (String) -> ()) {
        let findLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { placemarks, error in
            let cityName = placemarks!.last!.locality!
            let citysubName = placemarks!.last!.subLocality!
            
            let hi = cityName[cityName.startIndex...cityName.index(cityName.startIndex, offsetBy: 1)]
            
            let result = "\(hi), \(citysubName)"
            completionHandler(result)
        }
    }
    
}
