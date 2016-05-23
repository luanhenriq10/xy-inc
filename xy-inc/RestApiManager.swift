//
//  RestApiManager.swift
//  xy-inc
//
//  Created by Luan Damasceno on 18/05/16.
//  Copyright © 2016 luan. All rights reserved.
//

import UIKit
import SwiftyJSON

// For answers using singleton pattern
typealias ServiceResponse = (JSON, NSError?) -> Void

// Class that makes the comunication with server side
class RestApiManager: NSObject {
    
    static let sharedInstance = RestApiManager()
    
    let url = "https://www.omdbapi.com/?"
    
    // Get the movies
    func getMovies(onCompletion: (JSON) -> Void, name: String) {
        let route = url + "t=" + name
        
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    // Actually perform the requested
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path.stringByReplacingOccurrencesOfString(" ",
            withString: "+"))!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if data != nil{
                let json:JSON = JSON(data: data!)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        
        task.resume()
    }
    
    // Download image from url
    func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
}
