//
//  WeatherModel.swift
//  Clima
//
//  Created by Sampath Kumar Lam on 02/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    let temperature: Double
    let conditionId: Int
    let cityName: String
    
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String{
        switch conditionId{
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...532:
            return "cloud.rain"
        case 600...632:
            return "snow"
        case 700...781:
            return "cloud"
        case 800:
            return "sun.max"
        default:
            return "cloud"
        }
    }
}
