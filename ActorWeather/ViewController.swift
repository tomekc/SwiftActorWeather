//
//  ViewController.swift
//  ActorWeather
//
//  Created by Tomek Cejner on 14/07/14.
//  Copyright (c) 2014 Tomek Cejner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tview: UITableView!
    
    var weatherService:WeatherService?
    
    let ZERO_K:Float = 273.15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.weatherService = WeatherService(tv: tview)
        weatherService?.loadAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return weatherService!.numberOfRows()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell", forIndexPath: indexPath) as WeatherCell
        
//        println(weatherService?.cityData)
        
        let data  = weatherService?.model.getData(indexPath.row)
        let weather = data?.weather
        
        cell.cityName.text = data?.cityName
        
        let maxTemp = weather?.maxTemp
        cell.tempMax.text =  String(format: "%.1f", maxTemp.getOrElse(ZERO_K) - ZERO_K)
        
        let minTemp = weather?.minTemp
        cell.tempMin.text =  String(format: "%.1f", minTemp.getOrElse(ZERO_K) - ZERO_K)
        
        // "\(data?.weather?.maxTemp)"
//        cell.tempMin.text = "\(data?.weather?.minTemp)"
        
        return cell
        
    }
    

}

