//
//  MainScreenProtocols.swift
//  WeatherApp
//
//  Created by Борис Киселев on 10.04.2026.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    var interactor: MainInteractorProtocol? { get set }
    var router: MainRouterProtocol? { get set }

    func updateViewModel(_ viewModel: MainModel.MainViewModel)
    func showAllert(with error: WeatherError)
}

protocol MainInteractorProtocol {
    var presenter: MainPresenterProtocol? { get set }
    var weatherManager: WeatherManager? { get set }

    func loadWeather()
    func makeAnotherRequest()
}

protocol MainPresenterProtocol: AnyObject {
    var view: MainViewProtocol? { get set }

    func sendViewModel(_ response: MainModel.Response, cityName: String)
    func handleError(_ error: WeatherError)
}

protocol MainRouterProtocol: AnyObject {
    var source: MainViewController? { get set }

    func showAllert(with error: WeatherError)
}
