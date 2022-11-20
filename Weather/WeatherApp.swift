//
//  WeatherApp.swift
//  Weather
//
//  Created by Pablo Segovia on 20/11/2022.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
        }
    }
}
