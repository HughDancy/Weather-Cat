//
//  DayWeatherCell.swift
//  WeatherApp
//
//  Created by Борис Киселев on 14.04.2026.
//

import UIKit
import SnapKit

class DayWeatherCell: UITableViewCell {
    static let reuseIdentifier = String(describing: DayWeatherCell.self)

    // MARK: - Subview's
    private let dayLabel = BaseLabel(text: "", size: 16, weight: .semibold)
    private let iconImage = UIImageView()
    private let minTemperatureLabel = MinMaxLabel(type: .min, text: "", size: 16, textColor: .white, weight: .semibold)
    private let maxTemperatureLabel = MinMaxLabel(type: .max, text: "", size: 16, textColor: .white, weight: .semibold)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        selectionStyle = .none
    }

    // MARK: - Setup Hierarchy
    private func setupHierarchy() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(iconImage)
        contentView.addSubview(minTemperatureLabel)
        contentView.addSubview(maxTemperatureLabel)
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }

        iconImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(dayLabel.snp.trailing).offset(15)
        }

        minTemperatureLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImage.snp.trailing).offset(15)
        }

        maxTemperatureLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(minTemperatureLabel.snp.trailing).offset(10)
        }
    }

    // MARK: - Setup cell public method
    func setupCell(with item: ForecastDay) {
        dayLabel.text = DateFormatter.getDayDescription(item.date)
        dayLabel.addTextShadowAndOutline()
        let config = UIImage.SymbolConfiguration.preferringMulticolor()
        let image = UIImage(systemName: item.day.condition.weatherType.sfSymbolName, withConfiguration: config)
        iconImage.image = image
        minTemperatureLabel.changeText(String(item.day.mintempC))
        maxTemperatureLabel.changeText(String(item.day.maxtempC))
    }
}

