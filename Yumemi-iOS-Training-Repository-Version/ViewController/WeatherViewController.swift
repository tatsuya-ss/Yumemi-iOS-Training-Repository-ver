//
//  ViewController.swift
//  Yumemi-iOS-Training-Repository-Version
//
//  Created by 坂本龍哉 on 2021/04/19.
//

import UIKit

// 共通型
enum Weather {
    case sunny
    case cloudy
    case rainy
}
// 共通型
enum WeatherFethcingError: Error {
    case invalidRequest
    case parserError
    case unknown
}
// 共通型
struct WeatherState {
    var weather: Weather
    var max_temp: Int
    var min_temp: Int
    var date: String
}

// 共通型
protocol WeatherFethcingRepositoryProtocol {
    func fetch(at area: String, completion: (Result<WeatherState, WeatherFethcingError>) -> Void)
}


class WeatherViewController: UIViewController {
    private var weatherRepository: WeatherFethcingRepositoryProtocol? {
        didSet {
            registerModel()
        }
    }
    
    private(set) var weatherView: WeatherView = WeatherView()
    
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("天気ViewのviewDidLoadが終わった")
        weatherRepository = YumemiWeatherFetchingRepository()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("天気viewが現れる前")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("天気viewがレイアウトされる前")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("天気viewがレイアウトされた後")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("天気Viewが現れた！")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("天気Viewが消える前")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("天気Viewが消えた後")
    }
    
    
    private func registerModel() {
        weatherView.reloadButton.addTarget(self,
                                           action: #selector(onReloadButtonTapped),
                                           for: .touchUpInside)
        
        weatherView.closeButton.addTarget(self,
                                          action: #selector(onCloseButtonTapped),
                                          for: .touchUpInside)
    }
    
    @objc private func onReloadButtonTapped() {
        let area = """
{
           "area": "tokyo",
           "date": "2020-04-01T12:00:00+09:00"
         }
"""
        weatherRepository?.fetch(at: area,
                                 completion: { result in
                                    switch result {
                                    case let .success(weather):
                                        weatherView.weatherImageView.image = UIImage(named: weather.weatherImageName)
                                        weatherView.weatherImageView.tintColor = weather.imageColor
                                        weatherView.highestTemperatureLabel.text = String(weather.max_temp)
                                        weatherView.minimumTemperatureLabel.text = String(weather.min_temp)
                                    case let .failure(weatherFethcingError):
                                        let alert = weatherFethcingError.alert
                                        alert.addAction(UIAlertAction(title: "OK",
                                                                      style: .default,
                                                                      handler: nil))
                                        self.present(alert,
                                                     animated: true,
                                                     completion: nil)
                                    }
                                 })
    }
    
    @objc private func onCloseButtonTapped() {
//        performSegue(withIdentifier: "blackSegue", sender: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
}

private extension WeatherFethcingError {
    var alert: UIAlertController {
        switch self {
        case .unknown:
            return UIAlertController(title: "unknownエラー",
                                     message: "天気予報を取得できませんでした",
                                     preferredStyle: .alert)
        case .invalidRequest:
            return UIAlertController(title: "エラー",
                                     message: "weatherFethcingErrorです",
                                     preferredStyle: .alert)
            
        case .parserError:
            return UIAlertController(title: "エラー",
                                     message: "parserErrorです",
                                     preferredStyle: .alert)
            
        }
    }
}

private extension WeatherState {
    var imageColor: UIColor {
        switch self.weather {
        case .cloudy:
            return .gray
        case .rainy:
            return .blue
        case .sunny:
            return .red
        }
    }
    
    var weatherImageName: String {
        switch self.weather {
        case .cloudy:
            return "cloudy"
        case .rainy:
            return "rainy"
        case .sunny:
            return "sunny"
        }
    }
}

