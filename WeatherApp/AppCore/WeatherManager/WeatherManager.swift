//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Борис Киселев on 09.04.2026.
//

import Foundation

final class WeatherManager {

    // MARK: - Dependencies
    private let locationManager = GeolocationManager()
    private let weatherService = WeatherService()

    // MARK: - Properties
    private(set) var forecast: WeatherForecastResponse?
    private(set) var hourlyForecast: [HourWeather] = []
    private(set) var coordinates: (latitude: Double, longitude: Double)?
    private(set) var isLocationAuthorized = false

    // MARK: - Error Handling
    private(set) var lastError: WeatherError?

    // MARK: - Computed Properties
    var hasError: Bool {
        return lastError != nil
    }

    var hasData: Bool {
        return forecast != nil && !hourlyForecast.isEmpty
    }

    // MARK: - Public Methods r
    func loadWeatherData() async throws {
        lastError = nil

        do {
            let latitude = UserDefaults.standard.double(forKey: "userLatitude")
            let longitude = UserDefaults.standard.double(forKey: "userLongitude")

            guard latitude != 0 || longitude != 0 else {
                throw WeatherError.locationUnavailable
            }

            coordinates = (latitude, longitude)

            let weather = try await weatherService.fetchWeatherForecast(
                latitude: latitude,
                longitude: longitude
            )

            forecast = weather

            hourlyForecast = weatherService.getHourlyForecastStartingNow(forecast: weather)

            lastError = nil

        } catch let error as WeatherError {
            lastError = error
            throw error
        } catch {
            lastError = .unknown
            throw WeatherError.unknown
        }
    }

    func loadWeatherForDefaultCity() async throws {
        lastError = nil

        do {
            isLocationAuthorized = false
            coordinates = (55.7558, 37.6173)

            let weather = try await weatherService.fetchWeatherForecast(city: "Москва")
            forecast = weather
            hourlyForecast = weatherService.getHourlyForecastStartingNow(forecast: weather)

            lastError = nil

        } catch let error as WeatherError {
            lastError = error
            throw error
        } catch {
            lastError = .unknown
            throw WeatherError.unknown
        }
    }

    func loadWeatherWithFallback() async -> WeatherLoadingState {
        do {
            try await loadWeatherData()
            return .success(forecast!)
        } catch {
            do {
                try await loadWeatherForDefaultCity()
                return .success(forecast!)
            } catch {
                return .error(lastError ?? .unknown)
            }
        }
    }

    func getErrorMessage() -> String {
        return lastError?.errorDescription ?? "Неизвестная ошибка"
    }

    func resetError() {
        lastError = nil
    }

    func resetAllData() {
        forecast = nil
        hourlyForecast = []
        coordinates = nil
        lastError = nil
        isLocationAuthorized = false
    }

    func getCurrentState() -> WeatherLoadingState {
        if let error = lastError {
            return .error(error)
        } else if let forecast = forecast {
            return .success(forecast)
        } else {
            return .loading
        }
    }
}

// MARK: - State Enum для удобства работы с UI
enum WeatherLoadingState {
    case loading
    case success(WeatherForecastResponse)
    case error(WeatherError)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }

    var isError: Bool {
        if case .error = self { return true }
        return false
    }

    var errorMessage: String? {
        if case .error(let error) = self {
            return error.errorDescription
        }
        return nil
    }

    var forecast: WeatherForecastResponse? {
        if case .success(let forecast) = self {
            return forecast
        }
        return nil
    }
}



