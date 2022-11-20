//
//  WeatherService.swift
//  Weather
//
//  Created by Pablo Segovia on 20/11/2022.
//  Aca va a estar toda la información del usuario

import CoreLocation // Se necesita para conocer la ubicación del usuario
import Foundation

// Defino estructura de la API

public final class WeatherService: NSObject {
    private let locationManager = CLLocationManager()
    private let API_KEY = "acffdf99e3e5fa0fdf878d22782c3ebb"
    private var completionHandler: ((Weather) -> Void)?
    
    public override init() {
        super.init()
        locationManager.delegate = self
    } //: override init
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather) -> Void)) {
        self.completionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    } //: loadWeatherData
    
    // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
                let weather = Weather(response: response)
                self.completionHandler?(weather)
            } //: if response
        }.resume() //:URLSession.shared.dataTask
    } //: makeDataRequest
    
} //: WeatherService

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        makeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
} //: CLLocationManagerDelegate

struct APIResponse: Decodable {
    let name: String
    let main: APIMain
    let weather: [APIWeather] // es una lista que tiene un diccionario del tipo APIWeather
} //: APIResponse

struct APIMain: Decodable {
    let temp: Double
} //: APIMain

struct APIWeather: Decodable {
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main" // para poder acceder con mi nombre que tiene más sentido al key main de la API
    } //: Coding Keys
} //: APIWeather
