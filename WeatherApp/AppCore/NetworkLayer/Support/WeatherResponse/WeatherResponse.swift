//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Борис Киселев on 08.04.2026.
//

import Foundation

struct WeatherForecastResponse: Decodable {
    let location: Location
    let current: CurrentWeather
    let forecast: Forecast

    var todayForecast: ForecastDay? {
        return forecast.forecastday.first
    }
    
    var nextDaysForecast: [ForecastDay] {
        return Array(forecast.forecastday.dropFirst())
    }
}

// MARK: - Location
struct Location: Decodable {
    let name: String
    let country: String
    let localtime: String
    let tzId: String
    let localtimeEpoch: Int
    
    enum CodingKeys: String, CodingKey {
         case name, country
         case tzId = "tz_id"
         case localtimeEpoch = "localtime_epoch"
         case localtime
     }
    
    
    var timeZone: TimeZone? {
           return TimeZone(identifier: tzId)
       }
}

// MARK: - Current Weather
struct CurrentWeather: Decodable {
    let tempC: Double
    let condition: WeatherCondition
    let feelslikeC: Double
    let humidity: Int
    let windKph: Double
    let isDay: Int
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case feelslikeC = "feelslike_c"
        case humidity
        case windKph = "wind_kph"
        case isDay = "is_day"
    }
    
    var isDaytime: Bool {
        return isDay == 1
    }
}

// MARK: - Forecast
struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let day: DayWeather
    let hour: [HourWeather]
}

struct DayWeather: Decodable {
    let maxtempC: Double
    let mintempC: Double
    let condition: WeatherCondition
    let dailyChanceOfRain: Int
    let dailyChanceOfSnow: Int
    
    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyChanceOfSnow = "daily_chance_of_snow"
    }
    
    var averageTemp: Double {
        return (maxtempC + mintempC) / 2
    }
}
    // MARK: - Hour Weaher
struct HourWeather: Decodable {
    let time: String
    let tempC: Double
    let condition: WeatherCondition
    let chanceOfRain: Int
    let chanceOfSnow: Int
    let isDay: Int
    
    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case condition
        case chanceOfRain = "chance_of_rain"
        case chanceOfSnow = "chance_of_snow"
        case isDay = "is_day"
    }
    
    var hour: Int {
        let components = time.split(separator: " ")
        guard let timeString = components.last,
              let hour = Int(timeString.split(separator: ":").first ?? "0") else {
            return 0
        }
        return hour
    }
    
    var isDaytime: Bool {
        return isDay == 1
    }
}

// MARK: - Weather condition
struct WeatherCondition: Decodable {
    let text: String
    let code: Int

    var weatherType: WeatherType {
        return WeatherType.from(code: code, text: text)
    }
}

extension ForecastDay {
    func hoursFrom(currentHour: Int) -> [HourWeather] {
        return hour.filter { $0.hour >= currentHour }
    }

    func remainingHours(currentHour: Int) -> [HourWeather] {
        return hour.filter { $0.hour >= currentHour }
    }

    static func nextDayHours(from nextDayForecast: ForecastDay, upToHour: Int) -> [HourWeather] {
        return nextDayForecast.hour.filter { $0.hour <= upToHour }
    }
}
