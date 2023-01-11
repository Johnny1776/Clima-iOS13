//
//  WeatherManager.swift
//  Clima
//
//  Created by John Durcan on 16/12/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class WeatherManager: NSObject, URLSessionDelegate {

    
    let apiKey = "fece9b3734f8dbde73fc4409754c9480"
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?"
    var tempString: String { //A computed Variable..
        return String(format: "%.0f", weatherData!.main.temp - 273.15)
    }

    var weatherData: WeatherData?
//    var weatherIconData: UIImage?
    var computedWeatherCondition: String {
        switch weatherData!.weather.first!.id {
                    case 200...232:
            return  "cloud.bolt"
                    case 300...321:
            return "cloud.drizzle"
                    case 500...531:
            return "cloud.rain"
                    case 600...622:
            return "cloud.snow"
                    case 701...781:
            return "cloud.fog"
                    case 800:
            return "sun.max"
                    case 801...804:
            return "cloud.bolt"
                    default:
            return "cloud"
        }
    
    }
    var delegate: WeatherViewDelegate?

    /// Gets the weather by cityName Search
    /// - Parameters:
    /// - Parameter cityName: String
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)appid=\(apiKey)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    /// Gets the weather at GeoLocation
    /// - Parameters:
    /// - Parameter Geo: CLLocation
    func fetchWeather(Geo: CLLocation) {
        let lat = Geo.coordinate.latitude
        let lon = Geo.coordinate.longitude
        let urlString = "\(weatherURL)appid=\(apiKey)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    /// Performs URL weather request passed from fetchWeather
    /// Updates the weatherData and calls the delegate.didUpdateWeather
    ///
    /// - Parameters:
    /// - Parameter urlString: String or type URL
    func performRequest(with urlString:String){
        if let url = URL(string: urlString) { //We are creating a URL conforming to the URL Type
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        //    let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }

                  if let safeData = data {
//                    if urlString.contains("/img/wn/") {
// LEGACY                        self.weatherIconData = safeData
//                        self.delegate?.updateViews()
 //                   }else{
                      if let weather = self.parseJSON(safeData) {
                          self.weatherData = weather
                          self.delegate?.didUpdateWeather()
                      }

 //                   }
                }
            }
            task.resume()
        }
    }
    
//    func getIcon(){
//        var iconSource = "https://openweathermap.org/img/wn/"
//        iconSource += self.weatherData!.weather.first!.icon + "@2x.png"
//
//        performRequest(urlString: iconSource)
//
//
//    }
//    LEGACY FUNCTION To get icon from openweather
    


    func parseJSON(_ weatherData: Data) -> WeatherData?{
        let decoder = JSONDecoder() //
        do { //A Do catch loop will catch errors thrown by functions to a try statement.
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.name) //Because the decoder is set to the WeatherData Type, we can get that from the JSON Decoded Data Provided the key is in the JSON. In this instance, NAME will exist if the JSON is correctly formatted.
            let weather = try WeatherData.init(name: decodedData.name, wind: decodedData.wind, weather: decodedData.weather, main: decodedData.main)
            
            return weather
//            getIcon() //Legacy method to access icon from openweather servers.
            //Replaced with switch to SF Symbol.
//            self.weatherIconData = UIImage(systemName: getIcon())
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let protectionSpace = challenge.protectionSpace
        guard protectionSpace.authenticationMethod ==
            NSURLAuthenticationMethodServerTrust,
              protectionSpace.host.contains("openweathermap.org") else {
                  print("Ran default Handling")
                completionHandler(.performDefaultHandling, nil)
                return
        }
        completionHandler(.useCredential, nil)
        print("We got an SSL ERROR BABY!")
    }
    
//
//    func handle(data: Data?, response: URLResponse?, error: Error?) -> Void {
//        if error != nil {
//            print(error!)
//            return
//        }
//
//        if let safeData = data {
//            let dataString = String(data: safeData, encoding: .utf8)
//            print(dataString)
//        }
//    }
    
}
