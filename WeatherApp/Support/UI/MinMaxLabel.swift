//
//  MinMaxLabel.swift
//  WeatherApp
//
//  Created by Борис Киселев on 10.04.2026.
//

import UIKit

enum MinMaxType {
    case min
    case max
}

final class MinMaxLabel: BaseLabel {

    // MARK: - Private properties
    private let min = "Мин.: %@"
    private let max = "Макс.: %@"
    private let type: MinMaxType

    // MARK: - Init
    init(type: MinMaxType, text: String, size: CGFloat, textColor: UIColor, weight: UIFont.Weight) {
        self.type = type
        let completeString = type == .max ? String(format: max, text) : String(format: min, text)
        super.init(text: completeString, size: size, weight: weight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Change text
    func changeText(_ newText: String) {
        let newString = type == .max ? String(format: max, newText) : String(format: min, newText)
        self.text = newString
        self.addTextShadowAndOutline()
    }
}
