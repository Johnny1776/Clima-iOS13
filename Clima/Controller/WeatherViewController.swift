//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {


    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!

    @IBOutlet weak var searchField: UITextField!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization() // This will ask user for permissions. Need to deal with rejection.
        locationManager.delegate = self
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchField.delegate = self //So we are assigning this class as the delegate.
        // Do any additional setup after loading the view.
    }

  
    func getWeatherSearch(){
        if searchField.text != "" {
            weatherManager.fetchWeather(cityName: searchField.text!)
        }
        searchField.endEditing(true)
    }

    @IBAction func searchPressed(_ sender: Any) {
        getWeatherSearch()
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //The code that runs when the location is updated.
        locationManager.stopUpdatingLocation()
        if let locations = locations.last {
            print("Got update")
            weatherManager.fetchWeather(Geo: locations)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed get location")
    }
}

//MARK: - WeatherViewUpdate

extension WeatherViewController: WeatherViewDelegate {
 
    /// Updates the view with updated weather data
    ///
    ///  The function updates using DispatchQueue
    func didUpdateWeather(){
        //If we just update the screen without queing it, then we will get a runtime error not run from main thread.
        //This is because it is being run within a COMPLETION Handler. These are run in the background!
        let queue = DispatchQueue(label: "update")
        queue.async {
            if self.weatherManager.weatherData != nil {
                //update the fields if we found an entry
                DispatchQueue.main.async {
                    self.temperatureLabel.text = self.weatherManager.tempString
                    self.conditionLabel.text = self.weatherManager.weatherData!.weather.first?.description
                    self.cityLabel.text = self.weatherManager.weatherData!.name
              //LEGACY      self.conditionImageView.image = (self.weatherManager.weatherIconData != nil) ? UIImage(data: self.weatherManager.weatherIconData!) : UIImage(systemName: "network" )
                    self.conditionImageView.image = UIImage(systemName:  self.weatherManager.computedWeatherCondition)
                }
            }
        }
    }

    func didFailWithError(_ error: Error) {
        print(error)
    }
    
}


//MARK: - UIText Extension

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Return Key Pressed
        getWeatherSearch()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        searchField.text = ""
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //This is when a user taps outside the text field... We might not want to let them do that or validate the field...
        if textField.text != "" {
            return true
        }else{
            return false
        }
    }
}
