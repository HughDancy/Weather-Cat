//
//  BaseView.swift
//  WeatherApp
//
//  Created by Борис Киселев on 09.04.2026.
//

import UIKit

class BaseView: UIView {

    // MARK: - Init 
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View method
    func setupView() {
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Setup Hierarchy
    func setupHierarchy() { }
    
    // MARK: - Setup Layout
    func setupLayout() { }
}
