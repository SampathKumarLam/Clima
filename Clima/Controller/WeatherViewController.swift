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
    
    let weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert", message: "Accessing your present location", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestLocation()
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        // Do any additional setup after loading the view.
    }
    
}

//MARK: - UITextFieldDelegate


extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        if(textField.text != ""){
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cityName = textField.text
        weatherManager.fetchWeather(city: cityName!)
        textField.text = ""
    }
}
//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func updateUI(weather: WeatherModel){
        //conditionImageView.image = UIImage(systemName: weatherManager.imageViewName!)
        conditionImageView.image = UIImage(systemName: weather.conditionName)
        cityLabel.text = weather.cityName
        temperatureLabel.text = "\(weather.temperatureString)"
    }
    func didUpdateaWeather(weather: WeatherModel) {
        print("\(weather.temperatureString) :Weather VC ")
        updateUI(weather: weather)
        
    }
}

//MARK: - CoreLocationDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("latitude: \(lat)")
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
