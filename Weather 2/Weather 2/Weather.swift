//
//  Weather.swift
//  Weather 2
//
//  Created by Alberto Hirota on 8/17/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire

class Weather: UIViewController {
    private var _urlWeather: String = "http://api.openweathermap.org/data/2.5/weather?lat="
    private var _urlForecast: String = "http://api.openweathermap.org/data/2.5/forecast?lat="
    private var _apiKey: String = "&APPID=fb87404ddb00d4e8695017b02dd4b36f"
    private var _city: String?
    private var _temperature: String!
    private var _weatherCond: String!
    private var _tempMin: String!
    private var _tempMax: String!
    private var _wind: String!
    private var _humidity: String!
    private var _condNextDay1: String!
    private var _tempMin1: String!
    private var _tempMax1: String!
    private var _condNextDay2: String!
    private var _tempMin2: String!
    private var _tempMax2: String!
    private var _condNextDay3: String!
    private var _tempMin3: String!
    private var _tempMax3: String!
    private var _condNextDay4: String!
    private var _tempMin4: String!
    private var _tempMax4: String!
    private var _condNextDay5: String!
    private var _tempMin5: String!
    private var _tempMax5: String!
    private var _long: String!
    private var _lat: String!
    
    var city: String? {
        get {
            if _city == nil {
                _city = ""
            }
            print(_city)
            return _city
        }
    }
    var temperature: String? {
        get {
            if _temperature == nil {
                _temperature = ""
            }
            return _temperature
        }
    }
    var weatherCond: String? {
        get {
            if _weatherCond == nil {
                _weatherCond = ""
            }
            return _weatherCond
        }
    }
    var tempMin: String? {
        get {
            if _tempMin == nil {
                _tempMin = ""
            }
            return _tempMin
        }
    }
    var tempMax: String? {
        get {
            if _tempMax == nil {
                _tempMax = ""
            }
            return _tempMax
        }
    }
    var wind: String? {
        get {
            if _wind == nil {
                _wind = ""
            }
            return _wind
        }
    }
    var humidity: String? {
        get {
            if _humidity == nil {
                _humidity = ""
            }
            return _humidity
        }
    }
    var condNextDay1: String? {
        get {
            if _condNextDay1 == nil {
                _condNextDay1 = ""
            }
            return _condNextDay1
        }
    }
    var tempMin1: String? {
        get {
            if _tempMin1 == nil {
                _tempMin1 = ""
            }
            return _tempMin1
        }
    }
    var tempMax1: String? {
        get {
            if _tempMax1 == nil {
                _tempMax1 = ""
            }
            return _tempMax1
        }
    }
    var condNextDay2: String? {
        get {
            if _condNextDay2 == nil {
                _condNextDay2 = ""
            }
            return _condNextDay2
        }
    }
    var tempMin2: String? {
        get {
            if _tempMin2 == nil {
                _tempMin2 = ""
            }
            return _tempMin2
        }
    }
    var tempMax2: String? {
        get {
            if _tempMax2 == nil {
                _tempMax2 = ""
            }
            return _tempMax2
        }
    }
    var condNextDay3: String? {
        get {
            if _condNextDay3 == nil {
                _condNextDay3 = ""
            }
            return _condNextDay3
        }
    }
    var tempMin3: String? {
        get {
            if _tempMin3 == nil {
                _tempMin3 = ""
            }
            return _tempMin3
        }
    }
    var tempMax3: String? {
        get {
            if _tempMax3 == nil {
                _tempMax3 = ""
            }
            return _tempMax3
        }
    }
    var condNextDay4: String? {
        get {
            if _condNextDay4 == nil {
                _condNextDay4 = ""
            }
            return _condNextDay4
        }
    }
    var tempMin4: String? {
        get {
            if _tempMin4 == nil {
                _tempMin4 = ""
            }
            return _tempMin4
        }
    }
    var tempMax4: String? {
        get {
            if _tempMax4 == nil {
                _tempMax4 = ""
            }
            return _tempMax4
        }
    }
    var condNextDay5: String? {
        get {
            if _condNextDay5 == nil {
                _condNextDay5 = ""
            }
            return _condNextDay5
        }
    }
    var tempMin5: String? {
        get {
            if _tempMin5 == nil {
                _tempMin5 = ""
            }
            return _tempMin5
        }
    }
    var tempMax5: String? {
        get {
            if _tempMax5 == nil {
                _tempMax5 = ""
            }
            return _tempMax5
        }
    }
    
    func downloadWeather1(latitu: String, longit: String) {
        
        let url = NSURL(string: "\(_urlWeather)\(latitu)&lon=\(longit)\(_apiKey)&units=metric")!
        let session = NSURLSession.sharedSession()
        
        //let str = "http://api.openweathermap.org/data/2.5/weather?lat=43&lon=-79&APPID=fb87404ddb00d4e8695017b02dd4b36f"
        //let url = NSURL(string: str)!
        //Alamofire.request(.GET, url).responseJSON { response in
        session.dataTaskWithURL(url) {
            (data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseData = data {
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                    
                    //if let dict = result.value as? Dictionary<String, AnyObject> { //command Alamofire
                    if let dict = json as? Dictionary<String, AnyObject> {
                        if let city = dict["name"] as? String {
                            self._city = city
                            //self.viewController.cityLbl.text = self._city
                            print(self._city)
                        }
                        if let main1 = dict["main"] where main1.count > 0  {
                            print(main1.debugDescription)
                            if let temp = main1["temp"] as? Int {
                                self._temperature = "\(temp)"
                                //                        print(self._temperature)
                            }
                            if let humidity = main1["humidity"] as? Int {
                                self._humidity = "\(humidity)"
                                //                        print(self._humidity)
                            }
                            if let tempMax = main1["temp_max"] as? Int {
                                self._tempMax = "\(tempMax)\u{00B0}"
                                //                        print(self._tempMax)
                            }
                            if let tempMin = main1["temp_min"] as? Int {
                                self._tempMin = "\(tempMin)\u{00B0}"
                                //                        print(self._tempMin)
                            }
                        }
                        if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                            if let icon = weather[0]["icon"] as? String {
                                self._weatherCond = icon
                                //                        print(self._weatherCond)
                            }
                        }
                        if let windy = dict["wind"] {
                            if let speed = windy["speed"] {
                                self._wind = "\(speed)"
                                //                        print(self._wind)
                            }
                        }
                        print(self._city)
                        print(self._temperature)
                        print(self._humidity)
                        print(self._tempMax)
                        print(self._tempMin)
                        print(self._weatherCond)
                        print(self._wind)
                    }
                }catch {
                    print("could not serialize")
                }
            }
            } .resume()
        
        //viewController.updateUI()
    }
    func downloadForecast(latitu: String, longit: String) {
        
        let url = NSURL(string: "\(_urlForecast)\(latitu)&lon=\(longit)\(_apiKey)&units=metric")!
        let session1 = NSURLSession.sharedSession()
        
        
        //Alamofire.request(.GET, url).responseJSON { response in
        // let result = response.result
        //print(url)
        //print(result.value.debugDescription)
        
        session1.dataTaskWithURL(url) {
            (data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseData = data {
                
                do {
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                    
                    //if let dict = result.value as? Dictionary<String, AnyObject> { //command Alamofire
                    if let dictF = json as? Dictionary<String, AnyObject> {
                        
                        if let listF = dictF["list"] as? [Dictionary<String, AnyObject>] {
                            if let main1 = listF[0]["main"] {
                                if let tempMin1 = main1["temp_min"] as? Int {
                                    self._tempMin1 = "\(tempMin1)\u{00B0}"
                                }
                                if let tempMax1 = main1["temp_max"] as? Int {
                                    self._tempMax1 = "\(tempMax1)\u{00B0}"
                                }
                            }
                            if let weather1 = listF[0]["weather"] {
                                if let icon1 = weather1[0]["icon"] as? String {
                                    self._condNextDay1 = icon1
                                }
                            }
                            if let main2 = listF[1]["main"] {
                                if let tempMin2 = main2["temp_min"] as? Int {
                                    self._tempMin2 = "\(tempMin2)\u{00B0}"
                                }
                                if let tempMax2 = main2["temp_max"] as? Int {
                                    self._tempMax2 = "\(tempMax2)\u{00B0}"
                                }
                            }
                            if let weather2 = listF[1]["weather"] {
                                if let icon2 = weather2[0]["icon"] as? String {
                                    self._condNextDay2 = icon2
                                }
                            }
                            if let main3 = listF[2]["main"] {
                                if let tempMin3 = main3["temp_min"] as? Int {
                                    self._tempMin3 = "\(tempMin3)\u{00B0}"
                                }
                                if let tempMax3 = main3["temp_max"] as? Int {
                                    self._tempMax3 = "\(tempMax3)\u{00B0}"
                                }
                            }
                            if let weather3 = listF[2]["weather"] {
                                if let icon3 = weather3[0]["icon"] as? String {
                                    self._condNextDay3 = icon3
                                }
                            }
                            if let main4 = listF[3]["main"] {
                                if let tempMin4 = main4["temp_min"] as? Int {
                                    self._tempMin4 = "\(tempMin4)\u{00B0}"
                                }
                                if let tempMax4 = main4["temp_max"] as? Int {
                                    self._tempMax4 = "\(tempMax4)\u{00B0}"
                                }
                            }
                            if let weather4 = listF[3]["weather"] {
                                if let icon4 = weather4[0]["icon"] as? String {
                                    self._condNextDay4 = icon4
                                }
                            }
                            if let main5 = listF[4]["main"] {
                                if let tempMin5 = main5["temp_min"] as? Int {
                                    self._tempMin5 = "\(tempMin5)\u{00B0}"
                                }
                                if let tempMax5 = main5["temp_max"] as? Int {
                                    self._tempMax5 = "\(tempMax5)\u{00B0}"
                                }
                            }
                            if let weather5 = listF[4]["weather"] {
                                if let icon5 = weather5[0]["icon"] as? String {
                                    self._condNextDay5 = icon5
                                }
                            }
                        }
                    }
                } catch {
                    print("could not serialize")
                }
            }
            } .resume()
    }

}

