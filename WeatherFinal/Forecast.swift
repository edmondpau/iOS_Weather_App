//
//  Forecast.swift
//  WeatherFinal
//
//  Created by Edmond on 7/26/21.
//

import Foundation

struct Forecast: Codable {
    struct Current: Codable {
        let dt: Date
        let temp: Double
        let humidity: Int
        let feels_like: Double
        let uvi: Double
        
        struct Weather: Codable {
            let id: Int
            let description: String
            let icon: String
            var weatherIconURL: URL {
                let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                return URL(string: urlString)!
            }
        }
        let weather: [Weather]
    }
    let current: Current
}

