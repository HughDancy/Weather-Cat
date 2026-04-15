//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Борис Киселев on 10.04.2026.
//

import UIKit
import SnapKit

final class CurrentWeatherView: BaseView {

    // MARK: - Subview's
    private let containerView = BaseBlurView()

    private let cityLabel = BaseLabel(text: "Лондон", size: 30, weight: .semibold)

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let temperatureLabel = BaseLabel(text: "-2", size: 75, weight: .semibold)

    private let temperatureStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()

    private let maxLabel = MinMaxLabel(type: .max, text: "1", size: 20, textColor: .systemTeal, weight: .semibold)
    private let minLabel = MinMaxLabel(type: .min, text: "-5", size: 20, textColor: .systemTeal, weight: .semibold)

    private let minMaxStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    private let humidityLabel = BaseLabel(text: "", size: 20, weight: .semibold)
    private let windLabel = BaseLabel(text: "", size: 20, weight: .semibold)

    // MARK: - Private setup view mehtod
    override func setupView() {
        super.setupView()
        backgroundColor = .clear
    }

    // MARK: - Setup Hierarchy
    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(temperatureLabel)
        containerView.addSubview(cityLabel)
        containerView.addSubview(minMaxStack)
        minMaxStack.addArrangedSubview(maxLabel)
        minMaxStack.addArrangedSubview(minLabel)
        containerView.addSubview(humidityLabel)
        containerView.addSubview(windLabel)
    }

    // MARK: - Setup Layout
    override func setupLayout() {
        super.setupLayout()
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }

        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(75)
            make.height.equalTo(65)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        minMaxStack.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(minMaxStack.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        windLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Setup View public method
    func setupView(_ todayWeather: TodayWeather) {
        cityLabel.text = todayWeather.cityName
        temperatureLabel.text = String(todayWeather.temperatureCelsium)
        maxLabel.changeText(String(todayWeather.maxTemperature))
        minLabel.changeText(String(todayWeather.minTemperature))
        let config = UIImage.SymbolConfiguration.preferringMulticolor()
        let image = UIImage(systemName: todayWeather.imageName, withConfiguration: config)
        iconImageView.image = image
        humidityLabel.text = "Влажность \(todayWeather.humidity) %"
        windLabel.text = "Ветер \(todayWeather.windSpeed) км/ч"
        humidityLabel.addTextShadowAndOutline()
        windLabel.addTextShadowAndOutline()
        temperatureLabel.addTextShadowAndOutline()
        cityLabel.addTextShadowAndOutline()
    }
}
