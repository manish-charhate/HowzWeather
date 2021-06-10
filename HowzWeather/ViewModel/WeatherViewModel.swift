//
//  WeatherViewModel.swift
//  HowzWeather
//
//  Created by Manish Charhate on 02/06/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit.UIImage

class WeatherViewModel {

    // MARK:- Properties

    private let defaultCityName = "Kolkata"

    let locationName = Box("Loading...")
    let icon: Box<UIImage?> = Box(nil)
    let description = Box(" ")

    // MARK:- Initializers

    init() {
        changeLocation(to: defaultCityName)
    }

    // MARK:- Private helpers

    func changeLocation(to newLocation: String) {
        LocationGeoCoder.geocode(address: newLocation) { [weak self] locations in
            guard let location = locations.first,
                let strongSelf = self else {
                    return
            }

            strongSelf.locationName.value = location.name
            strongSelf.fetchWeatherForLocation(location)
            return
        }
    }

    private func fetchWeatherForLocation(_ location: Location) {
        WeatherDataService.fetchWeatherDataForLocation(
            with: location.latitude,
            and: location.latitude) { [weak self] weatherData, error in
                guard let weatherData = weatherData,
                    let strongSelf = self else {
                        return
                }
                DispatchQueue.main.async {
                    strongSelf.icon.value = UIImage(named: weatherData.iconName)
                    strongSelf.description.value = "\(weatherData.description) - \(weatherData.currentTemperature)"
                }
        }
    }
}
