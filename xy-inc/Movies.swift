//
//  Movies.swift
//  xy-inc
//
//  Created by Luan Damasceno on 20/05/16.
//  Copyright © 2016 luan. All rights reserved.
//

import UIKit

class Movies: NSObject {
    
    // MARK: Properties
    var title: String
    var imageLoaded: NSData!
    var year   : String
    var actrices: String
    var gender : String
    var runtime: String
    var savedImage: NSData!
    var urlImage: NSURL
    
    init(title: String, imageLoaded: NSData, year: String, actrices: String, gender: String, runtime: String, urlImage: NSURL){
        self.title          = title
        self.imageLoaded    = imageLoaded
        self.year           = year
        self.actrices       = actrices
        self.gender         = gender
        self.runtime        = runtime
        self.urlImage       = urlImage
    }
    
    

}
