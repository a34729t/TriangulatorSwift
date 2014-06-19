//
//  EstimoteView.swift
//  SwiftTri
//
//  Created by Nicolas Flacco on 6/18/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreLocation
import UIKit

class EstimoteView: UIView {
    var major, minor: String
    var step: Int
    var proximity: CLProximity
    
    init(frame: CGRect, image: UIImage, step: Int, major: String, minor: String) {
        self.major = major
        self.minor = minor
        self.step = step
        self.proximity = CLProximity.Unknown
        super.init(frame: frame)
        
        
    }
    
    override func drawRect(rect: CGRect) {
    }
}
