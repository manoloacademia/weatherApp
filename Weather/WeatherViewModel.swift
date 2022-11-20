//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Pablo Segovia on 20/11/2022.
//

import Foundation

private let defaultIcon = "❓"
private let iconMap = [
    "Drizzle": "🌨️",
    "Thunderstorm": "⛈️",
    "Rain": "🌧️",
    "Snow": "❄️",
    "Clear": "☀️",
    "Clouds": "☁️"
]

class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "City Name"
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = "--"
    @Published var weatherIcon: String = defaultIcon
    
    public let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    } //: init weatherService
    
    func refresh() {
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.async {
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)°C"
                self.weatherDescription = weather.description.capitalized
                self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
            }
        }
    } //: refresh
    
} //: WeatherViewModel
