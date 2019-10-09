//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Angela Yu on 24/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class WeatherDataModel {
    // Paso 7 Recuerda que a los datos hay que restarles 273 debido a que nos devuelve a kelvin y la convertimos  a celsius
    
    //Declare your model variables here
    var ciudad: String?
    var id: String?
    var tiempo: String?
    var des: String?
    var backg : String?
    
    convenience init(city: String? = nil, weatherId: Int, temp: Int ,descri: String? = nil){
        
        self.init()
        self.ciudad = city
        self.des = descri
        self.tiempo = "\(temp)º"
        self.id = self.updateWeatherIcon(condition: weatherId)
        self.backg = self.updateWeatherBackground(condition: weatherId)
    }
    
    
//    This method turns a condition code into the name of the weather condition image
    
    func updateWeatherIcon(condition: Int) -> String {
        
    switch (condition) {
    
        case 0...300 :
            return "tstorm1"
        
        case 301...500 :
            return "light_rain"
        
        case 501...600 :
            return "shower3"
        
        case 601...700 :
            return "snow4"
        
        case 701...771 :
            return "fog"
        
        case 772...799 :
            return "tstorm3"
        
        case 800 :
            return "sunny"
        
        case 801...804 :
            return "cloudy2"
        
        case 900...903, 905...1000  :
            return "tstorm3"
        
        case 903 :
            return "snow5"
        
        case 904 :
            return "sunny"
        
        default :
            return "dunno"
        }

    }
    
    func updateWeatherBackground(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "storm1_bg"
            
        case 301...500 :
            return "light_rain_bg"
            
        case 501...600 :
            return "shower3_bg"
            
        case 601...700 :
            return "snow4_bg"
            
        case 701...771 :
            return "fog_bg"
            
        case 772...799 :
            return "tstorm3_bg"
            
        case 800 :
            return "sunny_bg"
            
        case 801...804 :
            return "cloudy2_bg"
            
        case 900...903, 905...1000  :
            return "tstorm3_bg"
            
        case 903 :
            return "snow5_bg"
            
        case 904 :
            return "sunny_bg"
            
        default :
            return "dunno_bg"
        }
        
    }
}
