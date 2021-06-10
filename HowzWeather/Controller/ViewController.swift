//
//  ViewController.swift
//  HowzWeather
//
//  Created by Manish Charhate on 02/06/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!

    private let viewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherIconImageView.isHidden = true
        weatherDescriptionLabel.isHidden = true
        viewModel.locationName.bind { [weak self] locationName in
            self?.locationLabel.text = locationName
        }

        viewModel.icon.bind { [weak self] image in
            self?.weatherIconImageView.isHidden = false
            self?.weatherIconImageView.image = image
        }

        viewModel.description.bind { [weak self] description in
            self?.weatherDescriptionLabel.isHidden = false
            self?.weatherDescriptionLabel.text = description
        }
    }

    @IBAction func promptForLocation(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter location", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(
            title: "Submit",
            style: .default) { [weak self, unowned alertController] _ in
                guard let location = alertController.textFields?.first?.text else { return }
                self?.viewModel.changeLocation(to: location)
        })
        present(alertController, animated: true)
    }
}

