//
//  WeatherViewModelTests.swift
//  HowzWeatherTests
//
//  Created by Manish Charhate on 02/06/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import XCTest
@testable import HowzWeather

class WeatherViewModelTests: XCTestCase {

    func testChangeLocationUpdatesLocationName() {
        let expectation = self.expectation(description: "Find location using geocoder")
        let viewModel = WeatherViewModel()
        viewModel.locationName.bind {
            if $0.caseInsensitiveCompare("Richmond, VA") == .orderedSame {
                expectation.fulfill()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            viewModel.changeLocation(to: "Richmond, VA")
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

}
