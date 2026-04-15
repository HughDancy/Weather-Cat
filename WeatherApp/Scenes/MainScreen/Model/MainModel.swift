//
//  MainModel.swift
//  WeatherApp
//
//  Created by Борис Киселев on 14.04.2026.
//

import Foundation

struct TodayWeather {
    var cityName: String
    var temperatureCelsium: Double
    var minTemperature: Double
    var maxTemperature: Double
    var imageName: String
    var humidity: Int
    var windSpeed: Double
}

enum MainModel {
    struct Response {
        var forecast: WeatherForecastResponse
        var hourlyForecast: [HourWeather]
    }

    struct MainViewModel {
        var condition: WeatherCondition
        var todayWeather: TodayWeather
        var forecast: [HourWeather]
        var daysWeather: [ForecastDay]
    }
}

extension MainModel {
    static func createMockViewModel() -> MainViewModel {
        let condition = WeatherCondition(text: "sunny", code: 1000)
        let todayWeather = createMockTodayWeather(condition)
        let hour = HourWeather(time: "00", tempC: 10, condition: condition, chanceOfRain: 2, chanceOfSnow: 0, isDay: 1)
        let hourWeather = Array(repeating: hour, count: 20)

        let forecast = createMockHourWeather(with: condition, and: hour)
        let daysWeather = Array(repeating: forecast, count: 3)
        return MainModel.MainViewModel(condition: condition,
                                       todayWeather: todayWeather,
                                       forecast: hourWeather,
                                       daysWeather: daysWeather)
    }

    private static func createMockTodayWeather(_ condition: WeatherCondition) -> TodayWeather {
        return TodayWeather(cityName: "Москва",
                            temperatureCelsium: 10,
                            minTemperature: 5,
                            maxTemperature: 15,
                            imageName: "sun.max.fill",
                            humidity: 20,
                            windSpeed: 0.5)
    }

    private static func createMockHourWeather(with condition: WeatherCondition, and hour: HourWeather) -> ForecastDay {
        return  ForecastDay(date: "2026-05-24",
                            day: DayWeather(maxtempC: 10,
                            mintempC: 5,
                            condition: condition,
                            dailyChanceOfRain: 0,
                            dailyChanceOfSnow: 0),
                            hour: [hour])
    }
}
