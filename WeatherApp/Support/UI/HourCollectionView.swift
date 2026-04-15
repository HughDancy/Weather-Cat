//
//  HourCollectionView.swift
//  WeatherApp
//
//  Created by Борис Киселев on 10.04.2026.
//

import UIKit
import SnapKit

final class HourCollectionView: UIView {

    // MARK: - Private properties
    private var dataSource: [HourWeather]


    // MARK: - Subview
    private let containerView = BaseBlurView()

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HourWeatherCell.self, forCellWithReuseIdentifier: HourWeatherCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // MARK: - Init
    init(dataSource: [HourWeather]) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View private method
    private func setupView() {
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup Hierarchy
    private func setupHierarchy() {
        addSubview(containerView)
        containerView.addSubview(collectionView)
    }

    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(5)
        }
    }

    // MARK: - Public setup View
    func updateHourlyDataSource(with newDataSource: [HourWeather]) {
        dataSource = newDataSource
        print("THIS IS NEW COUNT OF DATA SOURCE - \(newDataSource.count)")
    }

    // MARK: - Create Layout
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            // Размер ячейки
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(60),  // Фиксированная ширина
                heightDimension: .fractionalHeight(1.0)  // 100% высоты контейнера
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Группа (содержит одну ячейку)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(60),
                heightDimension: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            // Секция
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous  // Горизонтальный скролл
            section.interGroupSpacing = 8  // Расстояние между ячейками
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

            return section
        }
    }
}

extension HourCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourWeatherCell.reuseIdentifier, for: indexPath) as? HourWeatherCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(with: dataSource[indexPath.row])
        return cell
    }
}
