//
//  WeatherViewController.swift
//  WeatherTalkProject
//
//  Created by 최윤제 on 2022/08/13.
//

import UIKit
import CoreLocation

import Kingfisher
import JGProgressHUD

class WeatherViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    let hud = JGProgressHUD()
    
    var weatherInfo: WeatherInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.backgroundColor = .clear
        timeLabel.font = UIFont(name: "KyoboHandwriting2020", size: 17)
        locationLabel.font = UIFont(name: "KyoboHandwriting2020", size: 22)
        locationManager.delegate = self
        weatherInfo = WeatherInfo(temp: 0.0, humidity: 0, windSpeed: 0.0, imageIcon: "04n")
    
        
    }

    @IBAction func resetButtonClicked(_ sender: UIButton) {
        checkUserDeviceLocationServiceAuthorization()
    }
}

//MARK: - TableView
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier , for: indexPath) as! WeatherTableViewCell
        
        if indexPath.row == 0 {
            cell.label.text = "  지금은  \(weatherInfo.temp)ºC 에요  "
        } else if indexPath.row == 1 {
            cell.weatherImageView.isHidden = true
            cell.label.isHidden = false
            cell.label.text = "  \(weatherInfo.humidity)% 만큼 습해요  "
        } else if indexPath.row == 2 {
            cell.label.text = "  \(weatherInfo.windSpeed)m/s의 바람이 불어요  "
        } else if indexPath.row == 3 {
            cell.weatherImageView.isHidden = false
            cell.label.isHidden = true
            cell.weatherImageView.kf.setImage(with: URL(string: "http://openweathermap.org/img/wn/\(weatherInfo.imageIcon)@2x.png"))
        } else {
            cell.weatherImageView.isHidden = true
            cell.label.isHidden = false
            cell.label.text = "  오늘도 행복한 하루 보내세요  "
        }
    

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == 3 ? 120 : 50

        
    }
    
    
}

//MARK: - 위치 권환 관련 User Defined 메서드
extension WeatherViewController {
    
    //Location7. iOS 버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인
    //위치 서비스가 켜져 있다면 권한을 요청하고, 꺼져 있다면 커스텀 얼럿으로 상황 알려주기
    //CLAuthorizationStatus
    //- denied: 허용 안함 / 설정에서 추후에 거부 / 위치 서비스 중지 / 비행기 모드
    //- restricted: 앱 권한 자체 없는 경우 / 자녀 보호 기능 같은걸로 아예 제한
    
func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus // 사용자 권환 확인
        
        if #available(iOS 14.0, *) {
            //인스턴스를 통해 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        //iOS 위치 서비스 활성화 여부 체크 :  locaitoSrvicesEnabled()
        if CLLocationManager.locationServicesEnabled() {
            //위치 서비스가 활성화 되어 있으므로, 위치 권한 요청 가능해서 위치 권한을 요청함
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
            showRequestLocationServiceAlert()
        }
    }
    
    //Location8. 사용자의 위치 권한 상태 확인
    //사용자가 위치를 허용했는 지, 거부했는 지, 아직 선택하지 않았는 지 등을 확인(단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // 위치에 대한 정확도를 지정 할 수 있다.
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
            //plist whenInUse 등록 되어야 -> request 메서드 사용이 가능하다
    
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            //사용자가 위치를 허용해둔 상태라면, srtartUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
            locationManager.startUpdatingLocation()
        default: print("DEFAULT")
            
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

//MARK: - LocationManager Delegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        //ex. 위도 경도 기반으로 날씨 정보를 조회
        //ex. 지도를 다시 세팅
        hud.show(in: view)
        if let coordinate = locations.last?.coordinate {
            LocationAPIManager.shared.requestLocation(coordinate: coordinate) { result in
                self.weatherInfo = result
                self.chatTableView.reloadData()
                self.hud.dismiss(animated: true)
                self.timeLabel.text = DateFormatter.nowTime
            }
            
            GeoCoderManager.shared.changeGeo(coordinate: coordinate) { result in
                self.locationLabel.text = result
            }
        }
        //위치 업데이트 멈춰!
        locationManager.stopUpdatingLocation()
    }
    
    //Location6. 사용자의 위치를 못 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    //Location9. 사용자의 권한 상태가 바뀔 때를 알려줌
    //거부 했다ㅏ 설정에서 변경했거나, 혹은 notDetermined에서 허용을 했거나 등
    //허용 했어서 위치를 가지고오는 중에, 설정에서 거부하고 돌아온다면??
    //iOS 14이상: 사용자의 권한 상태가 변경이 될 때, 위치 관리자 생성할 때 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    //iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}


