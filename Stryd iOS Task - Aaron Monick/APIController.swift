//
//  APIController.swift
//  Stryd iOS Task - Aaron Monick
//
//  Created by Aaron Monick on 8/13/15.
//  Copyright © 2015 aaronmonick. All rights reserved.
//

import Foundation

class APIController {
    
    func getJSONDataFromURL(url: NSURL, completion: ((results: NSDictionary?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                let jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(results: jsonResults)
                })
            } catch {
                print("JSON Error")
            }
        }.resume()
    }
    
}