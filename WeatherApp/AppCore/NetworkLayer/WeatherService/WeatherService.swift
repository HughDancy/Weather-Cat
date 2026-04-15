//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Борис Киселев on 08.04.2026.
//

import Foundation

enum API {
    static var weatherAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "WeatherAPIKey") as? String,
              !key.isEmpty,
              key != "$(WEATHER_API_KEY)"
        else {
            fatalError("API Key not found in Info.plist")
        }
        return key
    }
}

final class WeatherService {
    private let baseURL = "https://api.weatherapi.com/v1/forecast.json"

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10.0
        config.timeoutIntervalForResource = 20.0
        config.waitsForConnectivity = false
        return URLSession(configuration: config)
    }()

    // MARK: - Main methods for weather

    func fetchWeatherForecast(city: String) async throws -> WeatherForecastResponse {
        let apiKey = API.weatherAPIKey
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(encodedCity)&days=3&lang=ru"

        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        return try await performRequest(url: url)
    }

    func fetchWeatherForecast(latitude: Double, longitude: Double) async throws -> WeatherForecastResponse {
        let apiKey = API.weatherAPIKey
        let urlString = "\(baseURL)?key=\(apiKey)&q=\(latitude),\(longitude)&days=3&lang=ru"

        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        return try await performRequest(url: url)
    }

    // MARK: - Private request method

    private func performRequest(url: URL) async throws -> WeatherForecastResponse {
        do {
            let (data, response) = try await session.data(from: url)

            // Проверяем HTTP статус
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200...299:
                break // Все хорошо
            case 400:
                throw WeatherError.serverError(400)
            case 401:
                throw WeatherError.serverError(401)
            case 403:
                throw WeatherError.serverError(403)
            case 404:
                throw WeatherError.serverError(404)
            case 429:
                throw WeatherError.serverError(429)
            case 500...599:
                throw WeatherError.serverError(httpResponse.statusCode)
            default:
                throw WeatherError.invalidResponse
            }

            let decoder = JSONDecoder()
            return try decoder.decode(WeatherForecastResponse.self, from: data)

        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw WeatherError.decodingError

        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet,
                 .networkConnectionLost,
                 .dataNotAllowed:
                throw WeatherError.noInternetConnection

            case .timedOut:
                throw WeatherError.timeout

            case .cannotFindHost,
                 .cannotConnectToHost,
                 .dnsLookupFailed:
                throw WeatherError.noInternetConnection

            default:
                throw WeatherError.unknown
            }

        } catch let error as WeatherError {
            throw error

        } catch {
            throw WeatherError.unknown
        }
    }

    // MARK: - Filter with time zone
    private func getTimeZone(from forecast: WeatherForecastResponse) -> TimeZone {
        if let timeZone = TimeZone(identifier: forecast.location.tzId) {
            return timeZone
        }
        return TimeZone(identifier: "UTC") ?? TimeZone.current
    }

    func getCurrentHourInLocationTime(forecast: WeatherForecastResponse) -> Int {
        let locationTimeZone = getTimeZone(from: forecast)

        var calendar = Calendar.current
        calendar.timeZone = locationTimeZone

        let now = Date()
        return calendar.component(.hour, from: now)
    }

    func getCurrentMinuteInLocationTime(forecast: WeatherForecastResponse) -> Int {
        let locationTimeZone = getTimeZone(from: forecast)

        var calendar = Calendar.current
        calendar.timeZone = locationTimeZone

        let now = Date()
        return calendar.component(.minute, from: now)
    }

    func getRemainingTodayHoursAccurate(forecast: WeatherForecastResponse) -> [HourWeather] {
        guard let today = forecast.forecast.forecastday.first else { return [] }

        let locationTimeZone = getTimeZone(from: forecast)
        var calendar = Calendar.current
        calendar.timeZone = locationTimeZone

        let now = Date()
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)

        return today.hour.filter { hourWeather in
            let components = hourWeather.time.split(separator: " ")
            guard let timeString = components.last,
                  let hour = Int(timeString.split(separator: ":").first ?? "0") else {
                return false
            }

            if hour > currentHour {
                return true
            } else if hour == currentHour {
                return currentMinute < 30
            }
            return false
        }
    }

    func getAllTomorrowHours(forecast: WeatherForecastResponse) -> [HourWeather] {
        guard let tomorrow = forecast.forecast.forecastday.dropFirst().first else { return [] }
        return tomorrow.hour
    }

    func getHourlyForecastStartingNow(forecast: WeatherForecastResponse) -> [HourWeather] {
        let todayHours = getRemainingTodayHoursAccurate(forecast: forecast)
        let tomorrowHours = getAllTomorrowHours(forecast: forecast)
        return todayHours + tomorrowHours
    }

    func formatHourTime(_ timeString: String, forecast: WeatherForecastResponse) -> String {
        let components = timeString.split(separator: " ")
        guard let time = components.last else { return timeString }
        return String(time)
    }

    func getCurrentTimeInLocation(forecast: WeatherForecastResponse) -> String {
        let locationTimeZone = getTimeZone(from: forecast)
        let formatter = DateFormatter()
        formatter.timeZone = locationTimeZone
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
}


enum WeatherError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case noInternetConnection
    case timeout
    case serverError(Int)
    case locationUnavailable
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .invalidResponse:
            return "Ошибка сервера"
        case .decodingError:
            return "Ошибка обработки данных"
        case .noInternetConnection:
            return "Отсутствует интернет-соединение"
        case .timeout:
            return "Превышено время ожидания ответа от сервера"
        case .serverError(let code):
            return "Ошибка сервера: \(code)"
        case .locationUnavailable:
            return "Не удалось определить местоположение"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}


