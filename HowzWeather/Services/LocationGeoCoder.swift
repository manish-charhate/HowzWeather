//
//  LocationGeoCoder.swift
//  HowzWeather
//
//  Created by Manish Charhate on 02/06/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import CoreLocation

/**
 Contains method to convert address to `Location`
 */
struct LocationGeoCoder {

    static func geocode(address: String, completionHandler: @escaping ([Location]) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                error == nil else {
                    print("Geocoding error: (\(error!))")
                    return
            }
            let locations: [Location] = placemarks.compactMap { (placemark) -> Location? in
                guard let name = placemark.name,
                    let location = placemark.location else {
                        return nil
                }
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                let state = placemark.administrativeArea ?? ""
                let fullName = "\(name), \(state)"
                return Location(name: fullName, latitude: latitude, longitude: longitude)
            }
            completionHandler(locations)
        }
    }
}
