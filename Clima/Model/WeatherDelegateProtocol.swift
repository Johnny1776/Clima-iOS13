//
//  WeatherDelegateProtocol.swift
//  Clima
//
//  Created by John Durcan on 20/12/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherViewDelegate {
    func didUpdateWeather()
    func didFailWithError(_ error: Error)
}
