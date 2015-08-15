//
//  ViewController.swift
//  Stryd iOS Task - Aaron Monick
//
//  Created by Aaron Monick on 8/13/15.
//  Copyright © 2015 aaronmonick. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    var api = APIController()
    let url = NSURL(string: "https://www.stryd.com/b/interview/data")
    
    @IBOutlet weak var graphView: GraphView!
    
    @IBOutlet weak var avgPowerLabel: UILabel!
    @IBOutlet weak var maxPowerLabel: UILabel!
    @IBOutlet weak var avgHRLabel: UILabel!
    @IBOutlet weak var maxHRLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        api.getJSONDataFromURL(url!) { (results) -> Void in
            if let jsonResults = results {
                let totalPower = jsonResults["total_power_list"] as! [Int]
                let heartRate = jsonResults["heart_rate_list"] as! [Int]
                let avgPower = jsonResults["average_power"] as! Int
                let maxPower = jsonResults["max_power"] as! Int
                let avgHR = jsonResults["average_heart_rate"] as! Int
                let maxHR = jsonResults["max_heart_rate"] as! Int
                
                self.graphView.powerGraphPoints = totalPower
                self.graphView.hrGraphPoints = heartRate
                self.graphView.setNeedsDisplay()

                self.avgPowerLabel.text = "AVG: \(avgPower)"
                self.maxPowerLabel.text = "MAX: \(maxPower)"
                self.avgHRLabel.text = "AVG: \(avgHR)"
                self.maxHRLabel.text = "MAX: \(maxHR)"
            } else {
                print("Error fetching results")
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.graphView.setNeedsDisplay()
    }
}

