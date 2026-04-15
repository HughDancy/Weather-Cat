//
//  SplashView.swift
//  WeatherApp
//
//  Created by Борис Киселев on 09.04.2026.
//

import UIKit
import SnapKit

final class SplashView: BaseView {
    
    // MARK: - Subview's
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Weather Cat"
        label.textColor = .systemTeal
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 33, weight: .semibold)
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.tintColor = .systemTeal
        indicator.startAnimating()
        return indicator
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Hierarchy
    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(backgroundImage)
        sendSubviewToBack(backgroundImage)
        addSubview(titleLabel)
        addSubview(activityIndicator)
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        super.setupLayout()
        
        backgroundImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
}
