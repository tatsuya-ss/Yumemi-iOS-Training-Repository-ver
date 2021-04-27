//
//  WeatherModel.swift
//  Yumemi-iOS-Training-Repository-Version
//
//  Created by 坂本龍哉 on 2021/04/19.
//

import Foundation
import YumemiWeather

struct WeatherStateDTO : Codable {
    var weather: String
    var max_temp: Int
    var min_temp: Int
    var date: String
}


struct YumemiWeatherFetchingRepository : WeatherFethcingRepositoryProtocol {
    func fetch(at area: String, completion: (Result<WeatherState, WeatherFethcingError>) -> Void) {
        
        
        do {
            let jsonWeather = try YumemiWeather.fetchWeather(area)
            guard let weatherData = jsonWeather.data(using: .utf8) else { completion(.failure(.parserError))
                return
            }
            let decodeWeather = try JSONDecoder().decode(WeatherStateDTO.self, from: weatherData)
            completion(.success(WeatherState(dto: decodeWeather)))
        } catch YumemiWeatherError.unknownError{
            completion(.failure(WeatherFethcingError(yumemiError: YumemiWeatherError.unknownError)))
        } catch {
            completion(.failure(WeatherFethcingError(yumemiError: YumemiWeatherError.invalidParameterError)))
        }
    }
}

private extension WeatherState {
    init(dto: WeatherStateDTO) {  // WeatherStateDTO型を共通のWeatherState型に変換する
        self = WeatherState(weather: Weather(dto: dto.weather),
                            max_temp: dto.max_temp,
                            min_temp: dto.min_temp,
                            date: dto.date)
    }
}

private extension Weather {
    init(dto: String) {  // WeatherState型のweatherを共通のWeather型に変換する
        switch dto {
        case "cloudy":
            self = Weather.cloudy
        case "rainy":
            self = Weather.rainy
        case "sunny":
            self = Weather.sunny
        default:
            self = Weather.sunny
        }
    }
}

private extension WeatherFethcingError {
    init(yumemiError: YumemiWeatherError) {  // YumemiWeatherErrorを共通型のWeatherFethcingErrorに変換する
        switch yumemiError {
        case .unknownError:
            self = WeatherFethcingError.unknown
        case .invalidParameterError:
            self = WeatherFethcingError.invalidRequest
        }
    }
}
