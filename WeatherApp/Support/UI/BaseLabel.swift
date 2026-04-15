//
//  BaseLabel.swift
//  WeatherApp
//
//  Created by Борис Киселев on 10.04.2026.
//

import UIKit

class BaseLabel: UILabel {

    // MARK: - Init
    init(text: String, size: CGFloat, weight: UIFont.Weight) {
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        self.textColor = .white
        self.adjustsFontForContentSizeCategory = true // Адаптация под системные настройки
        self.adjustsFontSizeToFitWidth = true // Уменьшение шрифта при нехватке места
        self.minimumScaleFactor = 0.5
//        self.addTextShadowAndOutline()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
