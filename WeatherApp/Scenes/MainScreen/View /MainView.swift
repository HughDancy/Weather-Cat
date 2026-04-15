//
//  MainView.swift
//  WeatherApp
//
//  Created by Борис Киселев on 08.04.2026.
//

import UIKit
import SnapKit

final class MainView: UIView {

    // MARK: - Private properties
    private var hourDataSource = [HourWeather]()
    private var dayWeather = [ForecastDay]()

    // MARK: - Subview's
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let currentWeatherView = CurrentWeatherView()
    private lazy var hourWeatherCollection = HourCollectionView(dataSource: self.hourDataSource)
    private let daysWeatherTable = DayWeatherTable()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup view private method
    private func setupView() {
        backgroundColor = .clear
        setupHierarchy()
        setupLayout()
        currentWeatherView.layer.cornerRadius = 10
    }
    
    // MARK: - Setup Hierarchy
    private func setupHierarchy() {
        addSubview(backgroundImage)
        sendSubviewToBack(backgroundImage)
        addSubview(currentWeatherView)
        addSubview(hourWeatherCollection)
        addSubview(daysWeatherTable)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        backgroundImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview()
        }

        currentWeatherView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(35)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(self.snp.height).multipliedBy(0.4)
        }

        hourWeatherCollection.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherView.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(self.snp.height).multipliedBy(0.15)
        }

        daysWeatherTable.snp.makeConstraints { make in
            make.top.equalTo(hourWeatherCollection.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(self.snp.height).multipliedBy(0.18)
        }
    }
    
    // MARK: - Setup background image public method
    func setupBackground(with image: UIImage?) {
        backgroundImage.image = image
    }

    // MARK: - Setup weather public method
    func updateCurrentWeather(_ weather: TodayWeather) {
        currentWeatherView.setupView(weather)
    }

    func updateHourWeatherDataSource(with newDataSource: [HourWeather]) {
        hourWeatherCollection.updateHourlyDataSource(with: newDataSource)
    }

    func updateDaysWeather(with dataSource: [ForecastDay]) {
        daysWeatherTable.updateDataSource(dataSource)
    }
}
