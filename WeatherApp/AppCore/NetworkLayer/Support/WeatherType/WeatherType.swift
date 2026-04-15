//
//  WeatherType.swift
//  WeatherApp
//
//  Created by Борис Киселев on 08.04.2026.
//

import UIKit

enum WeatherType: String, CaseIterable {
    /// Ясная погода
    case sunny = "sunny"
    case clear = "clear"
    
    /// Облачность
    case partlyCloudy = "partlyCloudy"
    case cloudy = "cloudy"
    case overcast = "overcast"
    
    /// Туман и дымка
    case mist = "mist"
    case fog = "fog"
    
    /// Дождь (разной интенсивности)
    case lightRain = "lightRain"
    case moderateRain = "moderateRain"
    case heavyRain = "heavyRain"
    case freezingRain = "freezingRain"
    
    /// Снег
    case lightSnow = "lightSnow"
    case moderateSnow = "moderateSnow"
    case heavySnow = "heavySnow"
    case blizzard = "blizzard"
    
    /// Мокрый снег и град
    case sleet = "sleet"
    case icePellets = "icePellets"
    
    /// Гроза
    case thunderstorm = "thunderstorm"
    
    /// Неизвестный тип (fallback)
    case unknown = "unknown"
    
    // MARK: - Mapping
    static func from(code: Int, text: String) -> WeatherType {
        switch code {
        /// Ясно
        case 1000: return .sunny
            
        /// Облачность
        case 1003: return .partlyCloudy
        case 1006: return .cloudy
        case 1009: return .overcast
            
        /// Туман
        case 1030: return .mist
        case 1135, 1147: return .fog
            
        /// Лёгкий дождь / морось
        case 1063, 1150, 1153, 1180, 1183:
            return .lightRain
            
        /// Умеренный дождь
        case 1168, 1171, 1186, 1189, 1198, 1201, 1240:
            return .moderateRain
            
        /// Сильный дождь
        case 1192, 1195, 1243, 1246:
            return .heavyRain
            
        /// Ледяной дождь
        case 1072:
            return .freezingRain
            
        /// Лёгкий снег
        case 1066, 1114, 1210, 1213, 1255:
            return .lightSnow
            
        /// Умеренный и сильный снег
        case 1216, 1219, 1222, 1225, 1258:
            return .moderateSnow
            
        /// Сильный снег / метель
        case 1117:
            return .blizzard
            
        /// Мокрый снег
        case 1069, 1264:
            return .sleet
            
        /// Ледяные гранулы
        case 1237:
            return .icePellets
            
        /// Гроза
        case 1087, 1273, 1276, 1279, 1282:
            return .thunderstorm
            
        default:
            return fromText(text)
        }
    }
    
    private static func fromText(_ text: String) -> WeatherType {
        let lowercased = text.lowercased()

        if lowercased.contains("гроз") || lowercased.contains("thunder") {
            return .thunderstorm
        }
        if lowercased.contains("метель") || lowercased.contains("blizzard") {
            return .blizzard
        }
        if lowercased.contains("ливень") || lowercased.contains("torrential") {
            return .heavyRain
        }
        if lowercased.contains("снег") || lowercased.contains("snow") {
            return lowercased.contains("light") || lowercased.contains("небольшой") ? .lightSnow : .moderateSnow
        }
        if lowercased.contains("дожд") || lowercased.contains("rain") {
            if lowercased.contains("light") || lowercased.contains("небольшой") || lowercased.contains("морос") {
                return .lightRain
            }
            if lowercased.contains("heavy") || lowercased.contains("сильн") {
                return .heavyRain
            }
            return .moderateRain
        }
        if lowercased.contains("туман") || lowercased.contains("fog") {
            return .fog
        }
        if lowercased.contains("пасмурн") || lowercased.contains("overcast") {
            return .overcast
        }
        if lowercased.contains("облачн") || lowercased.contains("cloudy") {
            return .cloudy
        }
        if lowercased.contains("солнечн") || lowercased.contains("sunny") {
            return .sunny
        }
        if lowercased.contains("ясн") || lowercased.contains("clear") {
            return .clear
        }

        return .unknown
    }
    
    // MARK: - For UI
    var sfSymbolName: String {
        switch self {
        case .sunny, .clear: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .overcast: return "smoke.fill"
        case .mist, .fog: return "cloud.fog.fill"
        case .lightRain: return "cloud.drizzle.fill"
        case .moderateRain: return "cloud.rain.fill"
        case .heavyRain, .freezingRain: return "cloud.heavyrain.fill"
        case .lightSnow, .moderateSnow: return "cloud.snow.fill"
        case .heavySnow, .blizzard: return "wind.snow"
        case .sleet, .icePellets: return "cloud.hail.fill"
        case .thunderstorm: return "cloud.bolt.fill"
        case .unknown: return "questionmark"
        }
    }
    
    var russianName: String {
        switch self {
        case .sunny: return "Солнечно"
        case .clear: return "Ясно"
        case .partlyCloudy: return "Переменная облачность"
        case .cloudy: return "Облачно"
        case .overcast: return "Пасмурно"
        case .mist: return "Дымка"
        case .fog: return "Туман"
        case .lightRain: return "Небольшой дождь"
        case .moderateRain: return "Дождь"
        case .heavyRain: return "Сильный дождь"
        case .freezingRain: return "Ледяной дождь"
        case .lightSnow: return "Небольшой снег"
        case .moderateSnow: return "Снег"
        case .heavySnow: return "Сильный снег"
        case .blizzard: return "Метель"
        case .sleet: return "Мокрый снег"
        case .icePellets: return "Ледяной град"
        case .thunderstorm: return "Гроза"
        case .unknown: return "?"
        }
    }
    
    var typeOfImage: UIImage? {
        switch self {
        case .sunny, .clear: return UIImage(named: "day")
        case .mist, .fog: return UIImage(named: "mist")
        case .lightRain, .moderateRain, .heavyRain, .freezingRain: return UIImage(named: "rainy_01")
        case .lightSnow, .moderateSnow, .heavySnow, .blizzard, .sleet, .icePellets: return UIImage(named: "snow")
        case .thunderstorm: return UIImage(named: "rainy_00")
        case .partlyCloudy, .cloudy, .overcast: return UIImage(named: "cloudy")
        case .unknown: return UIImage(named: "wind_01")
        }
    }
}
