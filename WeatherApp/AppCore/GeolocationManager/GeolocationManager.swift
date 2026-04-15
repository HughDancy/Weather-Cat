//
//  GeolocationManager.swift
//  WeatherApp
//
//  Created by Борис Киселев on 09.04.2026.
//

import CoreLocation

final class GeolocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var onAuthorizationCompleted: (() -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func requestLocationPermissionAndGetLocation() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            onAuthorizationCompleted?()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            onAuthorizationCompleted?()
            saveMoscowCoordinates()
        @unknown default:
            break
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            onAuthorizationCompleted?()
            locationManager.startUpdatingLocation()
        } else if status == .denied {
            onAuthorizationCompleted?()
            saveMoscowCoordinates()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        saveCoordinates(latitude: location.coordinate.latitude,
                       longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        saveMoscowCoordinates()
    }
    
    // MARK: - Private Methods
    private func saveMoscowCoordinates() {
        let moscowLatitude = 55.7558
        let moscowLongitude = 37.6173
        saveCoordinates(latitude: moscowLatitude, longitude: moscowLongitude)
        print("📍 Используем координаты Москвы")
    }
    
    private func saveCoordinates(latitude: Double, longitude: Double) {
        UserDefaults.standard.set(latitude, forKey: "userLatitude")
        UserDefaults.standard.set(longitude, forKey: "userLongitude")
    }
}

extension GeolocationManager {
    func checkAuthorizationStatus() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
}
