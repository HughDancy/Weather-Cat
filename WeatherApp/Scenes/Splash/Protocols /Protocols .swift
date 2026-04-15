//
//  Protocols .swift
//  WeatherApp
//
//  Created by Борис Киселев on 10.04.2026.
//

import UIKit

protocol SplashViewProtocol: AnyObject {
    var interactor: SplashInteractorProtocol? { get set }
}

protocol SplashInteractorProtocol: AnyObject {
    var coordinator: SplashRoutingProtocol? { get set }
    var geoService: GeolocationManager? { get set }
    var weatherService: WeatherManager? { get set }

    func fetchLocationAndWeather()
}


