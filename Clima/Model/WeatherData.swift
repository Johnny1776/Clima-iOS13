//
//  WeatherData.swift
//  Clima
//
//  Created by John Durcan on 19/12/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let wind: Wind
    let weather: Array<Weather>
    let main: Main //Because this is also an object, we need to define the decodable struct for this one
    
    init(name: String, wind: Wind, weather: Array<Weather>, main: Main) {
        self.name = name
        self.wind = wind
        self.weather = weather
        self.main = main
    }
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

