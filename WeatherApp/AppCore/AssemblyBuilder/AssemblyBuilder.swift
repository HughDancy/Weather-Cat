//
//  AssemblyBuilder.swift
//  WeatherApp
//
//  Created by Борис Киселев on 08.04.2026.
//

import UIKit

final class AssemblyBuilder {
    
    func createSplashModule(with router: SplashRoutingProtocol, wheather: WeatherManager, geoLocation: GeolocationManager) -> UIViewController {
        let view = SplashViewController()
        let interactor = SplashInteractor()
        view.interactor = interactor
        interactor.coordinator = router
        interactor.weatherService = wheather
        interactor.geoService = geoLocation
        return view
    }
    
    func createMainModule(weatherService: WeatherManager) -> UIViewController {
        let mainViewControler = MainViewController()
        let interactor = MainScreenInteractor()
        let presenter = MainScreenPresenter()
        let router = MainScreenRouter()
        mainViewControler.interactor = interactor
        interactor.presenter = presenter
        interactor.weatherManager = weatherService
        presenter.view = mainViewControler
        mainViewControler.router = router
        router.source = mainViewControler
        return mainViewControler
    }
}
