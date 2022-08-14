//
//  ReuseableProtocol.swift
//  WeatherTalkProject
//
//  Created by 최윤제 on 2022/08/13.
//

import UIKit

protocol ReusableProtocol {
    static var identifier: String { get }
}

extension UITableViewCell: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
