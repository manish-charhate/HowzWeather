//
//  Weather.swift
//  HowzWeather
//
//  Created by Manish Charhate on 02/06/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {

    private static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let temperatureFormatter: NumberFormatter = {
        let tempFormatter = NumberFormatter()
        tempFormatter.numberStyle = .none
        return tempFormatter
    }()

    let observations: [WeatherObservations]

    enum CodingKeys: String, CodingKey {
        case observations = "data"
    }

    var currentTemperature: String {
        let temp = WeatherData.temperatureFormatter.string(
            from: observations[0].temperature as NSNumber) ?? ""
        return "\(temp)℉"
    }

    var iconName: String {
        observations[0].weather.icon
    }

    var description: String {
        observations[0].weather.description
    }

    var date: Date {
        // strip off the time
        let dateString = String(observations[0].datetime.prefix(10))

        // use current date if unable to parse
        return WeatherData.dateFormatter.date(from: dateString) ?? Date()
    }
}

struct WeatherObservations: Decodable {
    let temperature: Double
    let datetime: String
    let weather: Weather

    enum CodingKeys: String, CodingKey {
        case temperature = "temp", datetime, weather
    }
}

struct Weather: Decodable {
    let icon: String
    let description: String
}
