//
//  DateFormmater + EXT.swift
//  WeatherApp
//
//  Created by Борис Киселев on 15.04.2026.
//

import Foundation

extension DateFormatter {
    static func getDayDescription(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }

        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Сегодня"
        }

        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "ru_RU")
        weekdayFormatter.dateFormat = "EEEE"

        let weekday = weekdayFormatter.string(from: date)
        return weekday.capitalized
    }

}
