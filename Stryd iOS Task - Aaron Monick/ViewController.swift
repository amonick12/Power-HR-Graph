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
    
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var topMidValueLabel: UILabel!
    @IBOutlet weak var midValueLabel: UILabel!
    @IBOutlet weak var bottomMidValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        api.getJSONDataFromURL(url!) { (results) -> Void in
            if let jsonResults = results {
                let totalPower = jsonResults["total_power_list"] as! [Int]
                let heartRate = jsonResults["heart_rate_list"] as! [Int]
                
                self.graphView.powerGraphPoints = totalPower
                self.graphView.hrGraphPoints = heartRate
                self.graphView.setNeedsDisplay()

            } else {
                print("Error fetching results")
            }
        }

    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.graphView.setNeedsDisplay()
    }
}

