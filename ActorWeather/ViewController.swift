//
//  ViewController.swift
//  ActorWeather
//
//  Created by Tomek Cejner on 14/07/14.
//  Copyright (c) 2014 Tomek Cejner. All rights reserved.
//

import UIKit
import Swactor

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tview: UITableView 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell", forIndexPath: indexPath) as WeatherCell
        
        cell.cityName.text = "Foo"
        cell.tempMax.text = "99.9"
        cell.tempMin.text = "0.0"
        
        return cell
        
    }
    

}

