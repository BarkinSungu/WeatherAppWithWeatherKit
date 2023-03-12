//
//  ViewController.swift
//  WeatherAppWithWeatherKit
//
//  Created by Barkın Süngü on 9.03.2023.
//

import CoreLocation
import WeatherKit
import UIKit

final class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let service = WeatherService()
    
    @IBOutlet weak var conditionText: UILabel!
    @IBOutlet weak var tempatureText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getUserLocation()
        // Do any additional setup after loading the view.
    }
    
    func getUserLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func getWeather(location: CLLocation){
        Task{
            do{
                let result = try await service.weather(for: location)
                print("Current: " + String(describing: result.currentWeather))
                print("Daily: " + String(describing: result.dailyForecast))
                print("Minutely: " + String(describing: result.minuteForecast))
                
                tempatureText.text = String(describing: result.currentWeather.temperature)
                conditionText.text = String(describing: result.currentWeather.condition)
            }catch{
                print(String(describing: error))
            }
        }
    }
    
    func setupView(){
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else{
            return
        }
        locationManager.stopUpdatingLocation()
        getWeather(location: location)
    }


}

