//
//  HourWeatherCell.swift
//  WeatherApp
//
//  Created by Борис Киселев on 10.04.2026.
//

import UIKit
import SnapKit

final class HourWeatherCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: HourWeatherCell.self)

    // MARK: - Subview's
    private let timeLabel = BaseLabel(text: "", size: 17, weight: .regular)
    private lazy var iconImageView = UIImageView()
    private let temperatureLabel = BaseLabel(text: "", size: 19, weight: .semibold)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup cell private method
    private func setupCell() {
        backgroundColor = .clear
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup Hierarchy
    private func setupHierarchy() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(temperatureLabel)
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        iconImageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.centerX.equalToSuperview()
        }
        temperatureLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-7)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Setup Cell Public method
    func setupCell(with item: HourWeather) {
        timeLabel.text = String(item.hour)
        timeLabel.addTextShadowAndOutline()
        let config = UIImage.SymbolConfiguration.preferringMulticolor()
        let image = UIImage(systemName: item.condition.weatherType.sfSymbolName, withConfiguration: config)
        iconImageView.image = image
        temperatureLabel.text = String(item.tempC)
        temperatureLabel.addTextShadowAndOutline()
    }
}
