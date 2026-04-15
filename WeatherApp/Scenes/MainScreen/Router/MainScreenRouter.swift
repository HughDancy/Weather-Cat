//
//  MainScreenRouter.swift
//  WeatherApp
//
//  Created by Борис Киселев on 15.04.2026.
//

import UIKit

final class MainScreenRouter: MainRouterProtocol {
    weak var source: MainViewController?

    func showAllert(with error: WeatherError) {
        let alertController = createAlert(with: error.errorDescription)
        source?.navigationController?.present(alertController, animated: true)
    }

    // MARK: - Create Allert
    private func createAlert(with errorDescription: String?) -> UIAlertController {
        let alertController = UIAlertController(title: "Ошибка",
                                                message: "\(errorDescription ?? "Неизвестная ошибка"). Попробуйте еще раз. Если ошибка повторяется, попробуйте проверить соединение с интернетом и перезапустить приложение",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
            self?.source?.makeAnotherRequest()
        }
        alertController.addAction(okAction)
        return alertController
    }
}
