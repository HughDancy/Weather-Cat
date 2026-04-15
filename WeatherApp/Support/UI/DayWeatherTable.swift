//
//  DayWeatherTable.swift
//  WeatherApp
//
//  Created by Борис Киселев on 14.04.2026.
//

import UIKit
import SnapKit

final class DayWeatherTable: UIView {

    private var daysWeather = [ForecastDay]()

    // MARK: - Subview's
    private let containerView = BaseBlurView()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DayWeatherCell.self, forCellReuseIdentifier: DayWeatherCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        return tableView
    }()

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
        setupHierarchy()
        setupLayout()
    }
    // MARK: - Setup Hierarchy
    private func setupHierarchy() {
        addSubview(containerView)
        containerView.addSubview(tableView)
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(1)
        }

        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Update data source
    func updateDataSource(_ dataSource: [ForecastDay]) {
        daysWeather = dataSource
    }
}

extension DayWeatherTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysWeather.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayWeatherCell.reuseIdentifier, for: indexPath) as? DayWeatherCell else {
            return UITableViewCell()
        }
        cell.setupCell(with: daysWeather[indexPath.row])
        return cell
    }
}
