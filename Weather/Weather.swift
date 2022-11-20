//
//  Weather.swift
//  Weather
//
//  Created by Pablo Segovia on 20/11/2022.
//

import Foundation

public struct Weather {
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    
    init(response: APIResponse) {
        city = response.name
        temperature = "\(Int(response.main.temp))"
        description = response.weather.first?.description ?? "" // el first está para acceder al primero de la lista
        iconName = response.weather.first?.iconName ?? "" // el ?? es si no está definido
    } //: init
    
} //: Weather
