//
//  WeatherService.swift
//  ActorWeather
//
//  Created by Tomek Cejner on 16/07/14.
//  Copyright (c) 2014 Tomek Cejner. All rights reserved.
//

import Foundation
import UIKit
import Swactor


// ----------------------------------------------------------------------
// MODEL
class WeatherData {
    var Temp: Float?
    var MinTemp: Float?
    var MaxTemp: Float?
}
class WeatherResponse {
    var cityName:String?
    
    
}

// ----------------------------------------------------------------------
// MESSAGES
struct WeatherFetchMessage {
    let url:String
    let position:Int
}

// ----------------------------------------------------------------------
// ACTORS
class WeatherDownloader : Actor {
    
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session: NSURLSession

    init() {
        self.session = NSURLSession(configuration: self.config)
        super.init()
    }
    
    func getWeather(from:WeatherFetchMessage) {
        var url : NSURL = NSURL.URLWithString(from.url)
        var request: NSURLRequest = NSURLRequest(URL:url)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data:NSData!, response:NSURLResponse!, error) in
            // notice that I can omit the types of data, response and error
            // your code
            //println("Response", response)
            
            
            
            });
        
        task.resume()
    }
    
    override func receive(message: Any) {
        switch (message) {
            case let weatherFetch as WeatherFetchMessage:
                getWeather(weatherFetch)
            default:
                println("Unable to handle \(message)")
        }
    }
}

// ----------------------------------------------------------------------
class WeatherService {
    
    var tview: UITableView
    var cityCount: Int {
      get {
        return weatherURIs.count
      }
    }
    var actorSystem:ActorSystem
    var downloaderActor: ActorRef
    
    var weatherURIs = [
      "http://api.openweathermap.org/data/2.5/weather?q=London,uk",
      "http://api.openweathermap.org/data/2.5/weather?q=Paris,fr",
      "http://api.openweathermap.org/data/2.5/weather?q=Krakow,pl"
    ]
    
    
    init(tv:UITableView) {
        self.tview = tv
        
        self.actorSystem = ActorSystem()
        self.downloaderActor = actorSystem.actorOf(WeatherDownloader())
        
    }
    
    func loadAll() {
        var pos = 0
        for u in weatherURIs {
            downloaderActor ! WeatherFetchMessage(url: u, position: pos)
            pos++
        }
        
    }
    
}