//
//  ViewController.swift
//  Yumemi-iOS-Training-Repository-Version
//
//  Created by 坂本龍哉 on 2021/04/19.
//

import UIKit



class WeatherViewController: UIViewController {
    
    private var weatherModel: WeatherModel? {
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
        weatherModel = WeatherModel()
        weatherModel?.delegate = self
    }
    
    private func registerModel() {
        weatherView.reloadButton.addTarget(self,
                                           action: #selector(onReloadButtonTapped),
                                           for: .touchUpInside)
    }
    
    @objc private func onReloadButtonTapped() {
        let area = "tokyo"
        weatherModel?.returnWeatherOrError(area: area)
    }
    
}

extension WeatherViewController : WeatherModelDelegate {
    
    func configureImage(weather: String, color: UIColor) {
        weatherView.weatherImageView.image = UIImage(named: weather)
        weatherView.weatherImageView.tintColor = color
    }
    
    func weatherModel(_ weatherModel: WeatherModel, didReturnWeather weather: String) {
        switch weather {
        case "sunny":
            configureImage(weather: weather, color: .red)
        case "cloudy":
            configureImage(weather: weather, color: .gray)
        default:
            configureImage(weather: weather, color: .blue)
        }
    }
    
    func weatherModel(_ weatherModel: WeatherModel, didReturnError error: Error) {
        let alert = UIAlertController(title: "エラー",
                                      message: "天気予報を取得できませんでした",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in
                                        NSLog("The \"OK\" alert occured.\nエラー内容→\(error)")
                                      }))
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
}
