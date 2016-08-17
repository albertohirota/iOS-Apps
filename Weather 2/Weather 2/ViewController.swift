//
//  ViewController.swift
//  Weather 2
//
//  Created by Alberto Hirota on 8/17/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate  {
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dayOfWeekLbl: UILabel!
    @IBOutlet weak var tempMaxLbl: UILabel!
    @IBOutlet weak var tempMinLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var dayOfWeek1Lbl: UILabel!
    @IBOutlet weak var condImg1: UIImageView!
    @IBOutlet weak var tempMax1: UILabel!
    @IBOutlet weak var tempMin1: UILabel!
    @IBOutlet weak var dayOfWeek2: UILabel!
    @IBOutlet weak var condImg2: UIImageView!
    @IBOutlet weak var tempMax2: UILabel!
    @IBOutlet weak var tempMin2: UILabel!
    @IBOutlet weak var dayOfWeek3: UILabel!
    @IBOutlet weak var condImg3: UIImageView!
    @IBOutlet weak var tempMax3: UILabel!
    @IBOutlet weak var tempMin3: UILabel!
    @IBOutlet weak var dayOfWeek4: UILabel!
    @IBOutlet weak var condImg4: UIImageView!
    @IBOutlet weak var tempMax4: UILabel!
    @IBOutlet weak var tempMin4: UILabel!
    @IBOutlet weak var dayOfWeek5: UILabel!
    @IBOutlet weak var condImg5: UIImageView!
    @IBOutlet weak var tempMax5: UILabel!
    @IBOutlet weak var tempMin5: UILabel!
    
    var weather = Weather()
    //var weather: Weather! = Weather()
    //var weather: Weather!
    var locationManager = CLLocationManager()
    var latitude: String?
    var longitude: String?
    var actualTime: String?
    var weekToday: String?
    var week1: String?
    var week2: String?
    var week3: String?
    var week4: String?
    var week5: String?
    var weekName = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Mon", "Tue", "Wed", "Thu"]
    
    //typealias ScreenUpdate = () -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locateMe()
        timeNow()
        weekDay()
        print("DID we get here? - end of did view load")
    }
    func locateMe() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("location services are not enabled")
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let coordinations:CLLocationCoordinate2D = (manager.location?.coordinate)!
        let long = coordinations.longitude
        let lat = coordinations.latitude
        latitude = "\(lat)"
        longitude = "\(long)"
        print(long)
        print(lat)
        print("After DownloadUpdates and before Screen Update")
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
    }
    @IBAction func updatePressed(sender: UIButton) {
        updates()
    }
    @IBAction func screenPressed(sender: UIButton) {
        updateScreen()
        //print("After Screen Update")
    }
    func updateScreen() {
        cityLbl.text = weather.city
        mainImg.image = UIImage(named: weather.weatherCond!)
        temperatureLbl.text = weather.temperature
        timeLbl.text = actualTime
        dayOfWeekLbl.text = weekToday
        tempMaxLbl.text = weather.tempMax
        tempMinLbl.text = weather.tempMin
        windLbl.text = weather.wind
        humidityLbl.text = weather.humidity
        dayOfWeek1Lbl.text = week1
        condImg1.image = UIImage(named: weather.condNextDay1!)
        tempMax1.text = weather.tempMax1
        tempMin1.text = weather.tempMin1
        dayOfWeek2.text = week2
        condImg2.image = UIImage(named: weather.condNextDay2!)
        tempMax2.text = weather.tempMax2
        tempMin2.text = weather.tempMin2
        dayOfWeek3.text = week3
        condImg3.image = UIImage(named: weather.condNextDay3!)
        tempMax3.text = weather.tempMax3
        tempMin3.text = weather.tempMin3
        dayOfWeek4.text = week4
        condImg4.image = UIImage(named: weather.condNextDay4!)
        print(weather.condNextDay4)
        tempMax4.text = weather.tempMax4
        tempMin4.text = weather.tempMin4
        dayOfWeek5.text = week5
        condImg5.image = UIImage(named: weather.condNextDay5!)
        tempMax5.text = weather.tempMax5
        tempMin5.text = weather.tempMin5
    }
    func updates() {
        //Weather().downloadWeather1(latitude!, longit: longitude!)
        //Weather().downloadForecast(latitude!, longit: longitude!)
        weather.downloadWeather1(latitude!, longit: longitude!)
        weather.downloadForecast(latitude!, longit: longitude!)
    }
    func timeNow() {
        let hours = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let minutes = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())
        actualTime = "\(hours):\(minutes)"
        print(actualTime)
    }
    func weekDay() {
        let weekD = NSCalendar.currentCalendar().component(.Weekday, fromDate: NSDate())
        print(weekD)
        weekToday = weekName[weekD]
        week1 = weekName[weekD + 1]
        week2 = weekName[weekD + 2]
        week3 = weekName[weekD + 3]
        week4 = weekName[weekD + 4]
        week5 = weekName[weekD + 5]
    }
}


