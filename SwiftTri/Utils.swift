//
//  Utils.swift
//  SwiftTri
//
//  Created by Nicolas Flacco on 6/20/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import Foundation
import UIKit

// Image constants
let backgroundImage = UIImage(named: "sandycay")
let menuIconImage = UIImage(named: "menuIcon.png")
let scanIconImage = UIImage(named: "scanIcon.png")
let markerImage = UIImage(named: "markerIcon.png")
let beaconBlue = UIImage(named: "beaconBlue.png")
let beaconGreen = UIImage(named: "beaconGreen.png")
let beaconPurple = UIImage(named: "beaconPurple.png")

// Icons in on/off mode
let menuImgOff = filledImageFrom(image: menuIconImage, UIColor.blackColor())
let menuImgOn = filledImageFrom(image: menuIconImage, UIColor.grayColor())
let scanImgOff = filledImageFrom(image: scanIconImage, UIColor.blackColor())
let scanImgOn = filledImageFrom(image: scanIconImage, UIColor.grayColor())

// From http://stackoverflow.com/questions/845278/overlaying-a-uiimage-with-a-color?lq=1
func filledImageFrom(#image:UIImage, color:UIColor) -> UIImage {
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)

    // get a reference to that context we created
    let context:CGContextRef = UIGraphicsGetCurrentContext()
    
    // set the fill color
    color.setFill()
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, image.size.height)
    CGContextScaleCTM(context, 1.0, -1.0)
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn)
    let rect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
    CGContextDrawImage(context, rect, image.CGImage)
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn)
    CGContextAddRect(context, rect)
    CGContextDrawPath(context,kCGPathFill)
    
    // generate a new UIImage from the graphics context we drew onto
    let coloredImg:UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    //return the color-burned image
    return coloredImg
}