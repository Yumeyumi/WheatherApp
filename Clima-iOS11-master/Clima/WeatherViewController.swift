//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//
// Paso 1 Instalar cocopods, los ponemos en podfile. SwiftyJSON y Alamofire e instalamos
// Paso 2 Ponemos los permisos para gps de localitation description y otro location when use, ambos privacity
// Paso 3 Conseguimos la localización del móvil con Location manager. Importamos CoreLocation y Alamofire and SwiftyJSON, ponemos el delegate de LocationManager en la clase, e inicializamos una variable locationManager(let).
// Paso 4 Con la variable de location, usamos el delaget self para referenciarnos a nuestro dispositivo, luego usamos el acurracy para dictaminar la forma de medida, la autorización de permiso que hayamos usado antes un starUpdating y un stopUpdating para que no repita los datos.
// Paso 5 Tendremos que hacer el método de location (didUpdateLocations) para que nos de la longitud y latitud, después ponemos esos parametros en la url concatenandolo, y lo pasamos a el método getweather
// Paso 6 Tenemos que copiar en info, abriendo el code source por el error de app transport security un código después de NSLocationUsageDescription --> Siguiente paso, hacer los atributos en la clase, ve al modelo de datos
// Creamos el objeto de weather pata poder pasar los datos del JSON que nos ha dado el método get weather


import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON



class WeatherViewController: UIViewController,CLLocationManagerDelegate, ChangeCityDelegate  {
    
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    var objectDataWeather: WeatherDataModel?
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptiLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
      
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String) {
    
      Alamofire.request(url, method: .get,encoding: JSONEncoding.default, headers: nil).responseJSON {
       response in
        if let myJSON = response.data {
          self.updateWeatherData(response: myJSON)
        }
        self.locationManager.stopUpdatingLocation()
        
         }
    }
  
    
    //MARK: - JSON Parsing
    /***************************************************************/
    

   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(response: Data) {
        let objectJson = try! JSON(data: response)
        if(objectJson["cod"]==200){
            objectDataWeather = WeatherDataModel(city: objectJson["name"].stringValue,
            weatherId: objectJson["weather"][0]["id"].intValue,temp: objectJson["main"]["temp"].intValue-273, descri: objectJson["weather"][0]["description"].stringValue)
            updateUIWithWeatherData()
        
        }
        else{
            
           displayAlert()
            print("alerta")
        }
        
//        guard let currentWeather = objectDataWeather else{
//          return
//        }
       print(objectJson)
        
       

    }


    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData(){
        guard let currentWeather = objectDataWeather,
        let name = currentWeather.ciudad,
        let weather = currentWeather.id,
        let temp = currentWeather.tiempo,
        let descri = currentWeather.des,
        let backgr = currentWeather.backg
            else {
                return
        }
        weatherIcon.image = UIImage(named: weather)
        cityLabel.text = name
        temperatureLabel.text = "\(temp)"
        descriptiLabel.text = descri
        backgroundImage.image = UIImage(named: backgr)
        
    }
    
    //Funcion que muestra una alerta en caso de que escribas mal el nombre
    func displayAlert()
    {
        let alert = UIAlertController(title: "Cuidado!", message: "Has introducido mal el nombre", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var latitud: Double
        var longitud: Double
        latitud = locationManager.location?.coordinate.latitude.magnitude ?? 0
        longitud = locationManager.location?.coordinate.longitude.magnitude ?? 0
        let url = "\(WEATHER_URL)?lat=\(latitud)&lon=\(longitud)&appid=\(APP_ID)"
        getWeatherData(url: url)
        
        
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unaviable"
    }
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    
    func userEnteredANewCityName(city: String) {
        let url = "\(WEATHER_URL)?q=\(city)&appid=\(APP_ID)"
        getWeatherData(url: url)
        
    }
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destination = segue.destination as! ChangeCityViewController
            destination.delegate = self
        }
        
    }
    
    
    
    
}


