//
//  Box.swift
//  HowzWeather
//
//  Created by Manish Charhate on 02/06/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> ()

    private(set) var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: Listener?) {
        self.listener = listener
    }
}
