//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Борис Киселев on 10.04.2026.
//

import UIKit

protocol SplashRoutingProtocol {
    func showMain()
}

final class AppCoordinator {
    // MARK: - Private properties
    private let geolocationService = GeolocationManager()
    private let weatherService = WeatherManager()
    private let builder = AssemblyBuilder()

    // MARK: - Navigation Controller
    private var navigationController: UINavigationController?

    // MARK: - ChildControllers
    private var childViewControllers = [UIViewController]()

    // MARK: - Start method
    func start(window: UIWindow?) {
        navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

       showSplash()
    }

    // MARK: - Show splash method
    private func showSplash() {
        let splashVc = builder.createSplashModule(with: self, wheather: weatherService, geoLocation: geolocationService)
        childViewControllers.append(splashVc)
        navigationController?.setViewControllers(childViewControllers, animated: false)
    }
}

extension AppCoordinator: SplashRoutingProtocol {
    func showMain() {
        let mainScreen = builder.createMainModule(weatherService: weatherService)
        childViewControllers = [mainScreen]
        navigationController?.setViewControllers(childViewControllers, animated: false)
    }
}
