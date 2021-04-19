//
//  WeatherModel.swift
//  Yumemi-iOS-Training-Repository-Version
//
//  Created by 坂本龍哉 on 2021/04/19.
//

import Foundation
import YumemiWeather


private enum YumemiDTO: String {
    case sunny = "sunny"
    case cloudy = "cloudy"
    case rainy = "rainy"
}

struct YumemiWeatherFetchingRepository : WeatherFethcingRepositoryProtocol {
    func fetch(at area: String, completion: (Result<Weather, WeatherFethcingError>) -> Void) {
        do {
            let name = try YumemiWeather.fetchWeather(at: area)
            guard let dto = YumemiDTO(rawValue: name) else {
                completion(.failure(.parserError))  // YumemiWeatherから返ってきたエラーを共通型のエラーにして返す
                return
            }
            completion(.success(Weather(dto: dto)))  // YumemiWeatherから返ってきた天気名を共通型の天気にして返す
        } catch YumemiWeatherError.unknownError{
            completion(.failure(WeatherFethcingError(yumemiError: YumemiWeatherError.unknownError)))
        } catch {
            completion(.failure(WeatherFethcingError(yumemiError: YumemiWeatherError.invalidParameterError)))
        }
    }
}

private extension Weather {
    init(dto: YumemiDTO) {  // YumemiDTOを共通型に変換する処理
        switch dto {
        case .cloudy:
            self = Weather.cloudy
        case .rainy:
            self = Weather.rainy
        case .sunny:
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
