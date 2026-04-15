//
//  SplashInteractor.swift
//  WeatherApp
//
//  Created by Борис Киселев on 10.04.2026.
//

import Foundation

final class SplashInteractor: SplashInteractorProtocol {
    var geoService: GeolocationManager?
    var weatherService: WeatherManager?
    var coordinator: SplashRoutingProtocol?

    func fetchLocationAndWeather() {
        geoService?.onAuthorizationCompleted = { [weak self] in
            Task(priority: .userInitiated) {
                await self?.performSequentialLoading()
            }
        }
        geoService?.requestLocationPermissionAndGetLocation()
    }
}

extension SplashInteractor {
    private func performSequentialLoading() async {

        do {
            try await weatherService?.loadWeatherData()
            try await Task.sleep(nanoseconds: 300_000_000)
        } catch {
            print(error.localizedDescription)
        }

         await MainActor.run {
             navigateToMainScreen()
         }
     }

    private func navigateToMainScreen() {
        coordinator?.showMain()
    }
}
