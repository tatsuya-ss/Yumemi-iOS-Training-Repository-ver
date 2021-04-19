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
protocol WeatherFethcingRepositoryProtocol {
    func fetch(at area: String, completion: (Result<Weather, WeatherFethcingError>) -> Void)
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
        weatherRepository = YumemiWeatherFetchingRepository()
    }
    
    private func registerModel() {
        weatherView.reloadButton.addTarget(self,
                                           action: #selector(onReloadButtonTapped),
                                           for: .touchUpInside)
    }
    
    @objc private func onReloadButtonTapped() {
        let area = "tokyo"
        weatherRepository?.fetch(at: area,
                                 completion: { result in
                                    switch result {
                                    case let .success(weather):
                                        weatherView.weatherImageView.image = UIImage(named: weather.weatherImageName)
                                        weatherView.weatherImageView.tintColor = weather.imageColor
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

private extension Weather {
    var imageColor: UIColor {
        switch self {
        case .cloudy:
            return .gray
        case .rainy:
            return .blue
        case .sunny:
            return .red
        }
    }
    
    var weatherImageName: String {
        switch self {
        case .cloudy:
            return "cloudy"
        case .rainy:
            return "rainy"
        case .sunny:
            return "sunny"
        }
    }
}

