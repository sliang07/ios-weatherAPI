//
//  weather.swift
//  weather-api-ios
//
//  Created by Stanley on 6/30/16.
//  Copyright © 2016 Stanley. All rights reserved.
//
// The temperature T in degrees Fahrenheit (°F) is equal to the temperature T in Kelvin (K) times 9/5, minus 459.67


import Foundation
import Alamofire

class CurrentWeather {
    
    private var _cityname: String!
    private var _countryname: String!
    private var _tempMid: Double!
    private var _tempHigh: Double!
    private var _tempLow: Double!
    private var _windspeed: Double!
    private var _day: String!
    private var _currentTime: String!
    private var _city: String!
    private var _humidity: Int!
    
    var day: String {
        return _day
    }
    
    var cityname: String {
        return _cityname
    }
    
    var countryname: String{
        return _countryname
    }
    
    func GetWeather(weatherUrl: String) {
        
        let url = NSURL(string: weatherUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            
            let response = response.result
            
            print(response.value)
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
                //grabs city from json
                if let jsoncityname = dict["name"] as? String,
                    
                    //grabs country from json
                    let jsoncountryname = dict["sys"]!["country"] as? String,
                    
                    //grabs icon from json
                    let jsonIconID = dict["weather"]?[0]["icon"] as? String,
                    
                    //grabs Temp
                    let KelvinTempMain = dict["main"]!["temp"] as? Double,
                    let KelvinTempLow = dict["main"]!["temp_min"] as? Double,
                    let KelvinTempHigh = dict["main"]!["temp_max"] as? Double,
                    
                    //grabs windspeed from json
                    let WindSpeedinMeterperSec = dict["wind"]!["speed"] as? Double,
                    
                    //grabs humidity
                    let humidity = dict["main"]!["humidity"] as? Int,
                    
                    //Converts,grabs current time and day
                    let Time = dict["dt"] as? Double {
                    
                    let date = NSDate(timeIntervalSince1970: Time)
                    
                    let timeformater = NSDateFormatter()
                    timeformater.dateFormat = "h:mma"
                    let nowTime = timeformater.stringFromDate(date)
                    
                    
                    let dayformater = NSDateFormatter()
                    dayformater.dateFormat = "EEEE"
                    let nowDay = dayformater.stringFromDate(date)
                    
                    self._city = jsoncityname
                    self._countryname = jsoncountryname
                    self._tempLow = KelvinTempLow
                    self._tempMid = KelvinTempMain
                    self._tempHigh = KelvinTempHigh
                    self._windspeed = WindSpeedinMeterperSec
                    self._day = nowDay
                    self._currentTime = nowTime
                    self._humidity = humidity
                }
            }
        }
    }
}