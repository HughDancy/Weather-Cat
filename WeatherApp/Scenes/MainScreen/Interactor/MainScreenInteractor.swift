//
//  MainScreenInteractor.swift
//  WeatherApp
//
//  Created by Борис Киселев on 14.04.2026.
//

import Foundation

final class MainScreenInteractor: MainInteractorProtocol {
    var presenter: MainPresenterProtocol?
    var weatherManager: WeatherManager?

    func loadWeather() {
        if let error = weatherManager?.lastError {
            presenter?.handleError(error)
            return
        }

        guard let todayWeather = weatherManager?.forecast,
              let hourlyForecast = weatherManager?.hourlyForecast else {
            presenter?.handleError(WeatherError.unknown)
            return
        }

        let response = MainModel.Response(forecast: todayWeather, hourlyForecast: hourlyForecast)
        let cityName = weatherManager?.forecast?.location.name ?? "Москва"
        presenter?.sendViewModel(response, cityName: cityName)
    }

    func makeAnotherRequest() {
        Task {
            do {
                try await weatherManager?.loadWeatherData()
                try await Task.sleep(nanoseconds: 300_000_000)
            } catch {
                print(error.localizedDescription)
            }
            self.loadWeather()
        }
    }
}
