//
//  ViewController.swift
//  weather-api-ios
//
//  Created by Stanley on 6/29/16.
//  Copyright © 2016 Stanley. All rights reserved.
//
// this is how to convert UNIX time to whatever format
//        let test = 1467932346 as? Double
//        let date = NSDate(timeIntervalSince1970: test!)
//        let dateformater = NSDateFormatter()
//        dateformater.dateFormat = "E"
//        let datestring = dateformater.stringFromDate(date)
//        print(datestring)
//
// API id = 9670af645c31bf3849716b3cee4177b4
// example url: http://api.openweathermap.org/data/2.5/weather?lat=37.7873589&lon=-122.408227&APPID=9670af645c31bf3849716b3cee4177b4

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    //main forecast
    @IBOutlet weak var Current_time: UILabel!
    @IBOutlet weak var Current_day: UILabel!
    @IBOutlet weak var Current_degree: UILabel!
    @IBOutlet weak var Current_weather_icon: UIImageView!
    @IBOutlet weak var CountryLbl: UILabel!
    @IBOutlet weak var CityLbl: UILabel!
    @IBOutlet weak var Current_highLbl: UILabel!
    @IBOutlet weak var Current_lowLbl: UILabel!
    @IBOutlet weak var WindspeedLbl: UILabel!
    @IBOutlet weak var HumidityLbl: UILabel!
    
    //next hourly forecasts
    @IBOutlet weak var Next1time: UILabel!
    @IBOutlet weak var Next1icon: UIImageView!
    @IBOutlet weak var Next1high: UILabel!
    @IBOutlet weak var Next1low: UILabel!
    
    @IBOutlet weak var Next2time: UILabel!
    @IBOutlet weak var Next2icon: UIImageView!
    @IBOutlet weak var Next2high: UILabel!
    @IBOutlet weak var Next2low: UILabel!
    
    @IBOutlet weak var Next3time: UILabel!
    @IBOutlet weak var Next3icon: UIImageView!
    @IBOutlet weak var Next3high: UILabel!
    @IBOutlet weak var Next3low: UILabel!
    
    @IBOutlet weak var Next4time: UILabel!
    @IBOutlet weak var Next4icon: UIImageView!
    @IBOutlet weak var Next4high: UILabel!
    @IBOutlet weak var Next4low: UILabel!
    
    @IBOutlet weak var Next5time: UILabel!
    @IBOutlet weak var Next5icon: UIImageView!
    @IBOutlet weak var Next5high: UILabel!
    @IBOutlet weak var Next5low: UILabel!
    
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
//    @IBAction func getBtnPressed(sender: AnyObject) {
//        locationManager.requestLocation()
//    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var userLocation:CLLocation = locations[0] as! CLLocation
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        let weatherUrl = "\(weather_BASE)lat=\(lat)&lon=\(long)&\(api_idpart)"
        let FiveUrl = "\(weather_FIVE)lat=\(lat)&lon=\(long)&\(api_idpart)&cnt=5"
        GetWeather(weatherUrl)
        GetFiveWeather(FiveUrl)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func GetWeather(weatherUrl: String) {
        
        let url = NSURL(string: weatherUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            
            let response = response.result
            
//                  print(response.value)
            
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
                    
                    //updating data to view
                    self.CountryLbl.text = jsoncountryname
                    self.CityLbl.text = jsoncityname
                    self.Current_time.text = nowTime
                    self.Current_day.text = nowDay
                    let converted_temp_main = round(KelvinTempMain * 9/5 - 459.67)
                    self.Current_degree.text = "\(Int(converted_temp_main))°"
                    let img = UIImage(named: "\(jsonIconID)")
                    self.Current_weather_icon.image = img
                    let converted_temp_high = round(KelvinTempHigh * 9/5 - 459.67)
                    self.Current_highLbl.text = "\(Int(converted_temp_high))°"
                    let converted_temp_low = round(KelvinTempLow * 9/5 - 459.67)
                    self.Current_lowLbl.text = "\(Int(converted_temp_low))°"
                    
                    let converted_wind_speed = WindSpeedinMeterperSec * 36000 / 16090.3
                    let rounded_wind_speed = round(10 * converted_wind_speed)/10
                    self.WindspeedLbl.text = "\(rounded_wind_speed)MPH"
                    self.HumidityLbl.text = "\(humidity)%"
                    
                }
            }
        }
    }
    
    func GetFiveWeather(FiveUrl: String) {
        
        let url = NSURL(string: FiveUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            
            let response = response.result
            
//            print(response.value)
            if let dict = response.value as? Dictionary <String, AnyObject> {
                
                if let temphigh1 = dict["list"]![0]["main"]!!["temp_max"] as? Double,
                let templow1 = dict["list"]![0]["main"]!!["temp_min"] as? Double,
                let tempicon1 = dict["list"]![0]["weather"]!![0]["icon"] as? String,
                let temptime1 = dict["list"]![0]["dt"] as? Double,
                
                let temphigh2 = dict["list"]![1]["main"]!!["temp_max"] as? Double,
                let templow2 = dict["list"]![1]["main"]!!["temp_min"] as? Double,
                let tempicon2 = dict["list"]![1]["weather"]!![0]["icon"] as? String,
                let temptime2 = dict["list"]![1]["dt"] as? Double,
                
                let temphigh3 = dict["list"]![2]["main"]!!["temp_max"] as? Double,
                let templow3 = dict["list"]![2]["main"]!!["temp_min"] as? Double,
                let tempicon3 = dict["list"]![2]["weather"]!![0]["icon"] as? String,
                let temptime3 = dict["list"]![2]["dt"] as? Double,
                
                let temphigh4 = dict["list"]![3]["main"]!!["temp_max"] as? Double,
                let templow4 = dict["list"]![3]["main"]!!["temp_min"] as? Double,
                let tempicon4 = dict["list"]![3]["weather"]!![0]["icon"] as? String,
                let temptime4 = dict["list"]![4]["dt"] as? Double,
                
                let temphigh5 = dict["list"]![4]["main"]!!["temp_max"] as? Double,
                let templow5 = dict["list"]![4]["main"]!!["temp_min"] as? Double,
                let tempicon5 = dict["list"]![4]["weather"]!![0]["icon"] as? String,
                let temptime5 = dict["list"]![4]["dt"] as? Double {
                    
                    // converting time formats for all five
                    let date1 = NSDate(timeIntervalSince1970: temptime1)
                    let date2 = NSDate(timeIntervalSince1970: temptime2)
                    let date3 = NSDate(timeIntervalSince1970: temptime3)
                    let date4 = NSDate(timeIntervalSince1970: temptime4)
                    let date5 = NSDate(timeIntervalSince1970: temptime5)
                    
                    let timeformater = NSDateFormatter()
                    timeformater.dateFormat = "h:mma"
                    let nowTime1 = timeformater.stringFromDate(date1)
                    let nowTime2 = timeformater.stringFromDate(date2)
                    let nowTime3 = timeformater.stringFromDate(date3)
                    let nowTime4 = timeformater.stringFromDate(date4)
                    let nowTime5 = timeformater.stringFromDate(date5)
                 
                    //convert temp from Kelvin for all five
                    let converted_temp_high1 = round(temphigh1 * 9/5 - 459.67)
                    let converted_temp_low1 = round(templow1 * 9/5 - 459.67)
                    let converted_temp_high2 = round(temphigh2 * 9/5 - 459.67)
                    let converted_temp_low2 = round(templow2 * 9/5 - 459.67)
                    let converted_temp_high3 = round(temphigh3 * 9/5 - 459.67)
                    let converted_temp_low3 = round(templow3 * 9/5 - 459.67)
                    let converted_temp_high4 = round(temphigh4 * 9/5 - 459.67)
                    let converted_temp_low4 = round(templow4 * 9/5 - 459.67)
                    let converted_temp_high5 = round(temphigh5 * 9/5 - 459.67)
                    let converted_temp_low5 = round(templow5 * 9/5 - 459.67)
                    
                    //updating data onto view
                    self.Next1high.text = "\(Int(converted_temp_high1))°"
                    self.Next1low.text = "\(Int(converted_temp_low1))°"
                    let img1 = UIImage(named: "\(tempicon1)")
                    self.Next1icon.image = img1
                    self.Next1time.text = nowTime1
                    
                    self.Next2high.text = "\(Int(converted_temp_high2))°"
                    self.Next2low.text = "\(Int(converted_temp_low2))°"
                    let img2 = UIImage(named: "\(tempicon2)")
                    self.Next2icon.image = img2
                    self.Next2time.text = nowTime2

                    
                    self.Next3high.text = "\(Int(converted_temp_high3))°"
                    self.Next3low.text = "\(Int(converted_temp_low3))°"
                    let img3 = UIImage(named: "\(tempicon3)")
                    self.Next3icon.image = img3
                    self.Next3time.text = nowTime3

                    
                    self.Next4high.text = "\(Int(converted_temp_high4))°"
                    self.Next4low.text = "\(Int(converted_temp_low4))°"
                    let img4 = UIImage(named: "\(tempicon4)")
                    self.Next4icon.image = img4
                    self.Next4time.text = nowTime4

                    
                    self.Next5high.text = "\(Int(converted_temp_high5))°"
                    self.Next5low.text = "\(Int(converted_temp_low5))°"
                    let img5 = UIImage(named: "\(tempicon5)")
                    self.Next5icon.image = img5
                    self.Next5time.text = nowTime5

                }
            }
        }
    }
}


