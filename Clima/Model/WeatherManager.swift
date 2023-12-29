//
//  WeatherManager.swift
//  Clima
//
//  Created by Sampath Kumar Lam on 28/09/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateaWeather(weather: WeatherModel)
}
protocol CoreLocationDelegate{
    func didUpdateLocations()
}

class WeatherManager{
    var imageViewName: String?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=51d43977870b79523585998eabd1b2ed&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String){
        let urlString = "\(weatherURL)&q=\(city)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String){
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [self] data, response, error in
                if error != nil{
                    print(error!)
                    showErrorAlert()
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJson(weatherData: safeData){
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateaWeather(weather: weather)
                        }
                        
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJson(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weatherModel = WeatherModel(temperature: temp, conditionId: id, cityName: name)
            return weatherModel
        } catch{
            print(error)
            return nil
        }
    }
    
    func showErrorAlert(){
        let alert = UIAlertController(title: "Alert", message: "City not found, Please enter valid city name", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        alert.present(alert, animated: true)
    }
    
}
