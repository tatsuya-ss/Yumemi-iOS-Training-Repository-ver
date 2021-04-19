//
//  WeatherModel.swift
//  Yumemi-iOS-Training-Repository-Version
//
//  Created by 坂本龍哉 on 2021/04/19.
//

import Foundation
import YumemiWeather

protocol WeatherModelDelegate : AnyObject {
    func weatherModel(_ weatherModel: WeatherModel, didReturnWeather weather: String)
    
    func weatherModel(_ weatherModel: WeatherModel, didReturnError error: Error)

}



class WeatherModel {
    weak var delegate: WeatherModelDelegate?
    
    func returnWeatherOrError(area: String) {
        do {
            let randomWeather = try YumemiWeather.fetchWeather(at: area)
            delegate?.weatherModel(self, didReturnWeather: randomWeather)
        } catch YumemiWeatherError.unknownError {
            delegate?.weatherModel(self, didReturnError: YumemiWeatherError.unknownError)
        } catch {
            print("others")
        }
    }
}
