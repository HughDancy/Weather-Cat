//
//  MainScreenPresenter.swift
//  WeatherApp
//
//  Created by Борис Киселев on 14.04.2026.
//

import Foundation

final class MainScreenPresenter: MainPresenterProtocol {
   weak var view: MainViewProtocol?

    func sendViewModel(_ response: MainModel.Response, cityName: String) {
        let hourWeather = response.hourlyForecast
        let daylyWeather = response.forecast.forecast.forecastday
        let todayWeather = getTodayWeather(response.forecast)

        let viewModel = MainModel.MainViewModel(condition: response.forecast.current.condition,
                                                todayWeather: todayWeather,
                                                forecast: hourWeather,
                                                daysWeather: daylyWeather)
        view?.updateViewModel(viewModel)
    }

    private func getTodayWeather(_ forecast: WeatherForecastResponse) -> TodayWeather {
        let cityName = forecast.location.name

        return TodayWeather(cityName: cityName,
                            temperatureCelsium: forecast.current.tempC,
                            minTemperature: forecast.forecast.forecastday.first?.day.mintempC ?? 0.0,
                            maxTemperature: forecast.forecast.forecastday.first?.day.maxtempC ?? 0.0,
                            imageName: forecast.current.condition.weatherType.sfSymbolName,
                            humidity: forecast.current.humidity,
                            windSpeed: forecast.current.windKph)
    }

    func handleError(_ error: WeatherError) {
        let viewModel = MainModel.createMockViewModel()
        view?.updateViewModel(viewModel)
        view?.showAllert(with: error)
    }
}


