//
//  WeatherService.swift
//  ActorWeather
//
//  Created by Tomek Cejner on 16/07/14.
//  Copyright (c) 2014 Tomek Cejner. All rights reserved.
//

import Foundation
import UIKit
import JSONMapper
import Swactor

// ----------------------------------------------------------------------
// MODEL
class WeatherData : JSONSerializable {
    var temp: Float?
    var minTemp: Float?
    var maxTemp: Float?
    
    required init(_ c: JSONDeserializationContext) {
        temp = c.getFloat("temp")
        minTemp = c.getFloat("temp_min")
        maxTemp = c.getFloat("temp_max")
    }
    
    
}

class WeatherResponse : JSONSerializable, Printable {
    var cityName:String?
    var weather:WeatherData?
    
    required init(_ c: JSONDeserializationContext) {
        cityName = c.getString("name")
        weather = c.getObject("main", ofClass: WeatherData.self)
    }
    
    init() {
        
    }
    
    
    var description: String { get {
            return "Weather(\(self.cityName))"
        }
    }
    
}

// ----------------------------------------------------------------------
// MESSAGES
struct WeatherFetchMessage {
    let url:String
    let position:Int
}

struct UpdateTableMessage {
    let position:Int
}

// ----------------------------------------------------------------------
// ACTORS
class WeatherDownloader : Actor {
      
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session: NSURLSession
    let uiUpdateActor: ActorRef
    var cities:WeatherListModel

    init(uiactor:ActorRef, model:WeatherListModel) {
        self.session = NSURLSession(configuration: self.config)
        self.uiUpdateActor = uiactor
        self.cities = model
        super.init()
    }
    
    func getWeather(from:WeatherFetchMessage) {
        var url : NSURL = NSURL.URLWithString(from.url)
        var request: NSURLRequest = NSURLRequest(URL:url)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data:NSData!, response:NSURLResponse!, error) in

            let ctx = JSONMapper.context(data)
            let weatherData = WeatherResponse(ctx)
            
            println("Temperature in city \(weatherData.cityName) is now \(weatherData.weather?.temp)")
            
            self.cities.setData(weatherData, position: from.position)
            
            self.uiUpdateActor ! UpdateTableMessage(position: from.position)
            
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

class TableViewUpdateActor : ActorUI {
    
    var tableView:UITableView
    
    init(tableView:UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    override func receive(message: Any) {
        switch(message) {
            case let msg as UpdateTableMessage:
                let indexPath = NSIndexPath(forRow: msg.position, inSection: 0)
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                println("Reloaded row \(msg.position)")
            default:
                tableView.reloadData()
        }

    }
}
// ----------------------------------------------------------------------
class WeatherListModel {
    var cityData = Array(count: 6, repeatedValue: WeatherResponse())
    
    func setData(data:WeatherResponse, position:Int) {
        cityData[position] = data
    }
    
    func getData(position: Int) -> WeatherResponse {
        return cityData[position]
    }
    
    var cityCount: Int {
        get {
            return cityData.count
        }
    }
}

// ----------------------------------------------------------------------
class WeatherService {
    
    var tview: UITableView
    var actorSystem:ActorSystem
    var downloaderActor: ActorRef
    var uiUpdateActor: ActorRef
    
    var model = WeatherListModel()
    
    var weatherURIs = [
        "http://api.openweathermap.org/data/2.5/weather?q=London,uk",
        "http://api.openweathermap.org/data/2.5/weather?q=Paris,fr",
        "http://api.openweathermap.org/data/2.5/weather?q=Krakow,pl",
        "http://api.openweathermap.org/data/2.5/weather?q=San+Francisco,us",
        "http://api.openweathermap.org/data/2.5/weather?q=Paris,fr",
        "http://api.openweathermap.org/data/2.5/weather?q=Berlin,de",
      
    ]
    
    
    init(tv:UITableView) {
        
        self.tview = tv
        
        
        self.actorSystem = ActorSystem()
        
        self.uiUpdateActor = actorSystem.actorOf(TableViewUpdateActor(tableView: tview))
        self.downloaderActor = actorSystem.actorOf(WeatherDownloader(uiactor: self.uiUpdateActor, model :model))
        
    }
    
    func loadAll() {
        var pos = 0
        for u in weatherURIs {
            downloaderActor ! WeatherFetchMessage(url: u, position: pos)
            pos++
        }
        
    }
    
    func numberOfRows() -> Int {
        return model.cityCount
    }
    
}