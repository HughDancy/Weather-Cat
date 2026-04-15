//
//  BaseBlurView.swift
//  WeatherApp
//
//  Created by Борис Киселев on 10.04.2026.
//

import UIKit

final class BaseBlurView: UIView {

    // MARK: - Properties
    private let blurEffectView: UIVisualEffectView

    // MARK: - Init
    override init(frame: CGRect) {
        // Создаем blur эффект
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        blurEffectView = UIVisualEffectView(effect: blurEffect)

        super.init(frame: frame)

        setupBlur()
    }

    required init?(coder: NSCoder) {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        blurEffectView = UIVisualEffectView(effect: blurEffect)

        super.init(coder: coder)

        setupBlur()
    }

    private func setupBlur() {
        // Настройка blur
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.8

        addSubview(blurEffectView)

        // Затемнение для лучшей читаемости контента
        let darkOverlay = UIView()
        darkOverlay.layer.cornerRadius = 10
        darkOverlay.clipsToBounds = true
        darkOverlay.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        darkOverlay.frame = bounds
        darkOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.clipsToBounds = true
        addSubview(darkOverlay)
    }
}
