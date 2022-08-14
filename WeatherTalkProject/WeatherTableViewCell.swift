//
//  WeatherTableViewCell.swift
//  WeatherTalkProject
//
//  Created by 최윤제 on 2022/08/13.
//

import UIKit

class WeatherTableViewCell: UITableViewCell, UITableViewDelegate{

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        weatherImageView.layer.cornerRadius = 10
        label.font = UIFont(name: "KyoboHandwriting2020", size: 17)
    }
    


}
