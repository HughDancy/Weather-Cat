//
//  SplashViewController.swift
//  WeatherApp
//
//  Created by Борис Киселев on 09.04.2026.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Protocol Properties
    var interactor: SplashInteractorProtocol?

    // MARK: - Private properties
    private var mainView: SplashView?
    private let geolocationManager = GeolocationManager()
    private let weatherManager = WeatherManager()
    private let assemblyBuilder = AssemblyBuilder()
    
    override func loadView() {
        mainView = SplashView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchLocationAndWeather()
    }
}

extension SplashViewController: SplashViewProtocol { }
