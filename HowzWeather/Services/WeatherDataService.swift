//
//  WeatherDataService.swift
//  HowzWeather
//
//  Created by Manish Charhate on 02/06/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import Foundation

enum WeatherDataFetchError: Error {
  case invalidResponse
  case noData
  case failedRequest
  case invalidData
}

class WeatherDataService {

    typealias WeatherDataFetchCompletion = (WeatherData?, WeatherDataFetchError?) -> ()

    private static let apiKey = "733a66bfebfe4dee89d789045be34788"
    private static let host = "api.weatherbit.io"
    private static let path = "/v2.0/current"
    private static let fahrenheit = "I"

    static func fetchWeatherDataForLocation(with latitude: Double,
                                            and longitude: Double,
                                            completion: @escaping WeatherDataFetchCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = path
        urlBuilder.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "units", value: fahrenheit),
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)")
        ]
        guard let url = urlBuilder.url else { return }

        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("Failed request from Weatherbit: \(error!.localizedDescription)")
                completion(nil, .failedRequest)
                return
            }

            guard let data = data else {
                print("No data returned from Weatherbit")
                completion(nil, .noData)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("Unable to process Weatherbit response")
                completion(nil, .invalidResponse)
                return
            }

            guard response.statusCode == 200 else {
                print("Failure response from Weatherbit: \(response.statusCode)")
                completion(nil, .failedRequest)
                return
            }

            do {
                let decoder = JSONDecoder()
                let weatherData: WeatherData = try decoder.decode(WeatherData.self, from: data)
                completion(weatherData, nil)
            } catch {
                print("Unable to decode Weatherbit response: \(error.localizedDescription)")
                completion(nil, .invalidData)
            }
        }
        dataTask.resume()
    }
}
