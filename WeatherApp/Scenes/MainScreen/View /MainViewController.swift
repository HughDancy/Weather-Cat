//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Борис Киселев on 08.04.2026.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var mainView: MainView?
    var interactor: MainInteractorProtocol?
    var router: MainRouterProtocol?

    override func loadView() {
        mainView = MainView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.loadWeather()
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Func for ther router
    func makeAnotherRequest() {
        interactor?.makeAnotherRequest()
    }
}

// MARK: - Extnesion
extension MainViewController {
    private func showAllertWeatherNotDownload() {
        
    }
}

extension MainViewController: MainViewProtocol {
    func updateViewModel(_ viewModel: MainModel.MainViewModel) {
        mainView?.updateDaysWeather(with: viewModel.daysWeather)
        mainView?.updateHourWeatherDataSource(with: viewModel.forecast)

        mainView?.updateCurrentWeather(viewModel.todayWeather)
        mainView?.setupBackground(with: viewModel.condition.weatherType.typeOfImage)
    }

    func showAllert(with error: WeatherError) {
        router?.showAllert(with: error)
    }
}
