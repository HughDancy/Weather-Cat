//
//  ViewController.swift
//  WeatherApp
//
//  Created by Борис Киселев on 07.04.2026.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        self.getWeatherRequest()
    }
    
    private func getWeatherRequest() {
        Task {
            let service = WeatherService()
            do {
                let weather = try await service.fetchWeatherForecast(city: "Moscow")
                let grouped = service.getHourlyForecastStartingNow(forecast: weather)
                
                let currentHour = Calendar.current.component(.hour, from: Date())
                print("🕐 Текущее время: \(currentHour):\(Calendar.current.component(.minute, from: Date()))")
                
                // Сегодняшние часы
//                if !grouped.today.isEmpty {
//                    print("\n📅 Сегодня (с текущего часа):")
//                    for hour in grouped.today {
//                        let timeFormatted = service.formatHourTime(hour.time)
//                        let isCurrentHour = hour.hour == currentHour
//                        let prefix = isCurrentHour ? "🔴 Сейчас" : "   "
//                        print("\(prefix) \(timeFormatted): \(hour.tempC)°C, \(hour.condition.weatherType.russianName)")
//                    }
//                }
//                
//                // Завтрашние часы (все 24)
//                if !grouped.tomorrow.isEmpty {
//                    print("\n📅 Завтра (весь день):")
//                    for hour in grouped.tomorrow {
//                        let timeFormatted = service.formatHourTime(hour.time)
//                        print("   \(timeFormatted): \(hour.tempC)°C, \(hour.condition.weatherType.russianName)")
//                    }
//                }
                print("Текущая погода - \(weather.current.tempC) C, \(weather.current.condition)")
                for weather in grouped {
                    
                    print("\(weather.hour) : 00 : \(weather.tempC) C, \(weather.condition.text)")
                }
                
//                print("\n📊 Итого:")
//                print("   Сегодня осталось: \(grouped.today.count) часов")
//                print("   Завтра: \(grouped.tomorrow.count) часов")
//                print("   Всего: \(grouped.today.count + grouped.tomorrow.count) часов")
                
            } catch {
                print("Ошибка: \(error)")
            }
        }
//        let apiKey = "7eae04b60946498590c100043260704"
//        let urlString = "http://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\("55.75"),\("37.62")"
//        guard let url = URL(string: urlString) else {
//              print("❌ Неверный URL")
//              return
//          }
//          
//          let task = URLSession.shared.dataTask(with: url) { data, response, error in
//              // Проверяем ошибки
//              if let error = error {
//                  print("❌ Ошибка запроса: \(error.localizedDescription)")
//                  return
//              }
//              
//              // Проверяем, что данные есть
//              guard let data = data else {
//                  print("❌ Нет данных")
//                  return
//              }
//              
//              do {
//                  let 
//              }
//              
//              // Выводим JSON в виде строки
//              if let jsonString = String(data: data, encoding: .utf8) {
//                  print("✅ Полученный JSON:\n\(jsonString)")
//              }
//              
//              // Или красиво отформатированный JSON
//              do {
//                  let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//                  let prettyJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
//                  if let prettyJsonString = String(data: prettyJsonData, encoding: .utf8) {
//                      print("\n📋 Отформатированный JSON:\n\(prettyJsonString)")
//                  }
//              } catch {
//                  print("❌ Ошибка парсинга JSON: \(error)")
//              }
//          }
//          
//          task.resume()
    }


}

