//
//  EstimoteView.swift
//  SwiftTri
//
//  Created by Nicolas Flacco on 6/18/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreLocation
import UIKit

class EstimoteView: UIView, UIGestureRecognizerDelegate {

    var major, minor: String
    var step: CGFloat
    var proximity: CLProximity
    var coordinateLabel: UILabel
    var lastLocation: CGPoint
    
    init(frame: CGRect, image: UIImage, step: CGFloat, major: String, minor: String) {
        // Initialize stuff
        self.major = major
        self.minor = minor
        self.step = step
        self.proximity = CLProximity.Unknown
        self.coordinateLabel = UILabel(frame: frame)
        self.lastLocation = CGPoint()
        
        super.init(frame: frame)
        
        // Gesture recognizer
        let panRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
        self.gestureRecognizers = [panRecognizer]
        
        // Estimote image
        let imageView: UIImageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: self.frame.size))
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(imageView)
        
        // Label for coordinates
        self.coordinateLabel.textAlignment = NSTextAlignment.Center
        self.coordinateLabel.center = CGPointMake(self.frame.width/2, self.frame.height/2)
        self.setCoordinates(self.center)
        self.addSubview(self.coordinateLabel)
    }
    
    func setCoordinates(point: CGPoint) {
        let x: Int = Int(point.x/self.step)
        let y: Int = Int(point.y/self.step)
        self.coordinateLabel.text = "(\(x),\(x))"
    }
    
    func detectPan(uiPanGestureRecognizer: UIPanGestureRecognizer) {
        // Remember the original position
        if(uiPanGestureRecognizer.state == UIGestureRecognizerState.Began) {
            self.lastLocation = self.center
        }
        
        // Handle panning and end (snap to grid)
        if(uiPanGestureRecognizer.state != UIGestureRecognizerState.Ended) {
            // Keep on panning
            let translation = uiPanGestureRecognizer.translationInView(self.superview)
            self.center = CGPoint(x: self.lastLocation.x + translation.x, y: self.lastLocation.y + translation.y)
            self.setCoordinates(self.center)
        } else {
            // Snap to grid
            var newCenter: CGPoint = self.center
            newCenter.x = self.step * CGFloat(floor(Double(newCenter.x / self.step) + 0.5))
            newCenter.y = self.step * CGFloat(floor(Double(newCenter.y / self.step) + 0.5))
            
            UIView.animateWithDuration(0.1,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations:{ self.center = newCenter}, completion: nil)
            
            self.center = newCenter
            self.setCoordinates(self.center)
            
            println("endPan (\(newCenter.x),\(newCenter.y))")
        }
    }
    
    
}
