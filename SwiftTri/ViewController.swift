//
//  ViewController.swift
//  SwiftTri
//
//  Created by Nicolas Flacco on 6/18/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

// WARNING: Cannot use Images.xcassets with Swift on iOS 7 with XCode Beta 1 (Beta 2 works). As a workaround,
// use absolute path as shown here: http://stackoverflow.com/questions/24069479/swift-playgrounds-with-uiimage
// Naturally, this is a shitshow cause it won't work on an iOS 7 device cause it needs Images.xcassets.

// TODO: This should really all be autolayout-ed

import CoreLocation
import UIKit

class ViewController: UIViewController, BeaconManagerDelegate {
    // global config?
    let numberColumns: Int = 10
    
    // general properties
    var beaconManager: BeaconManager?
    var editMode: Bool = false
    var scanMode: Bool = false
    
    // iBeacons
    var blueEstimote, greenEstimote, purpleEstimote: EstimoteView!
    var iBeacons: EstimoteView[] = []

    // UI
    var gridView: GridView?
    var markerView: UIImageView?
    var menuButton, scanButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.beaconManager = sharedBeaconManager
        if !CLLocationManager.locationServicesEnabled() {
            // TODO: Alert, once alerts work without crashing app
        }

        // Set background image
        let backgroundImageView: UIImageView = UIImageView(image: backgroundImage)
        self.view.addSubview(backgroundImageView)
        
        // Draw grid
        let gridView: GridView = GridView(frame: self.view.frame, columns: numberColumns)
        gridView.alpha = 0.25;
        self.view.addSubview(gridView);
        self.gridView = gridView // This seems really awkward
        
        // Create iBeacons
        let width: CGFloat = self.view.frame.size.width;
        let height: CGFloat = self.view.frame.size.height;
        let point0: CGPoint = CGPointMake(width/3, height/1.5);
        let point1: CGPoint = CGPointMake(width/6, height/8);
        let point2: CGPoint = CGPointMake(width/1.5, height/3);

        self.blueEstimote = self.createBeaconView(image: beaconBlue,
            coordinates:point0,
            major:BEACON_BLUE_MAJOR,
            minor:BEACON_BLUE_MINOR);
        self.greenEstimote = self.createBeaconView(image: beaconGreen,
            coordinates:point1,
            major:BEACON_GREEN_MAJOR,
            minor:BEACON_GREEN_MINOR);
        self.purpleEstimote = self.createBeaconView(image: beaconPurple,
            coordinates:point2,
            major:BEACON_BLUE_MAJOR,
            minor:BEACON_BLUE_MINOR);

        self.iBeacons = [self.blueEstimote, self.greenEstimote, self.purpleEstimote];
        for estimote: EstimoteView in self.iBeacons {
            // NOTE: These settings don't seem to work when set in view initializer
            estimote.userInteractionEnabled = false
            estimote.coordinateLabel.hidden = true
            self.view.addSubview(estimote)
        }
        
        // Make menu button (delta)
        let menuButton: UIButton = self.makeMenuButton(image: menuImgOff, left:true)
        menuButton.addTarget(self, action: "menuButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(menuButton)
        self.menuButton = menuButton
        
        // Make scan button (antenna)
        let scanButton: UIButton = self.makeMenuButton(image: scanImgOff, left:false)
        scanButton.addTarget(self, action: "scanButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(scanButton)
        self.scanButton = scanButton
        
        // Make location marker
        let markerView:UIImageView = UIImageView(image: markerImage)
        let marker:CGPoint = self.updateLocationMarker()
        markerView.frame = CGRect(x: marker.x, y: marker.y - (133/6), width: 150/3, height: 133/3)
        self.view.addSubview(markerView)
        self.markerView = markerView
        
        // TODO: Check if bluetooth is on/off
    }

    // BeaconManager Delegate Methods
    
    func discoveredBeacon(#major: String, minor: String, proximity: CLProximity) {
        println("VC major:\(major) minor:\(minor) distance:\(proximity)");
        
        // Update estimote ranges
        for estimote:EstimoteView in self.iBeacons {
            if estimote.major == major && estimote.minor == minor {
                estimote.proximity = proximity
            }
        }
        
        // Update location marker position
        let marker:CGPoint = self.updateLocationMarker()
        self.markerView!.frame = CGRect(x: marker.x, y: marker.y - (133/6), width: 150/3, height: 133/3)
    }
    
    // Marker Helpers
    
    func updateLocationMarker() -> CGPoint {
        
        // Handle unknown case (no iBeacons in range) -> Move marker offscreen
        // TODO: Turn this into a map function?
        var num:Int = 0
        for estimote in self.iBeacons {
            if (estimote.proximity == CLProximity.Unknown) {
                num++
            }
        }
        if num == self.iBeacons.count {
            return CGPoint(x: -100.0,y: -100.0) // Off screen
        }
        
        // TODO:
        // 1 ... N-1 unknown case?
        // If marker would be offscreen, find the nearest point within 50 px of border?
        
        // All known case:
        // We want to weight nearer iBeacons more than further ones. We simply create an array of
        // x-coordinates, and the nearer an iBeacon is, the more times we add it to the array, so
        // that the average value is influenced more!
        
        // HACK ALERT: I use two arrays as hack cause otherwise I'd do NSValue (for lack of tuple) cause arrays cannot take primitives
        // TODO: Use map/zip/etc.
        var xTotal:Int = 0;
        var yTotal:Int = 0;
        var xCount:Int = 0;
        var yCount:Int = 0;
        for estimote:EstimoteView in self.iBeacons {
            for i:Int in 0...CLProximity2Int(estimote.proximity) {
                xTotal += Int(estimote.center.x)
                yTotal += Int(estimote.center.y)
                xCount++
                yCount++
            }
        }

        return CGPoint(x: xTotal/xCount, y: yTotal/yCount)
    }
    
    func CLProximity2Int(proximity:CLProximity) -> Int {
        switch proximity {
        case .Unknown:
            return 0;
        case .Far:
            return 1;
        case .Near:
            return 5;
        case .Immediate:
            return 20;
        default:
            return 0; // Also handles .Unknown case
        }
    }
    
    // Button Delegates
    
    func menuButtonClicked(sender: UIButton!) {
        println("menuButtonClicked")
        
        // Toggle edit mode
        self.editMode = !self.editMode
        
        // Change 1) color of button 2) grid transparency (alpha)
        if self.editMode {
            self.menuButton!.setImage(menuImgOn, forState: UIControlState.Normal)
            self.gridView!.alpha = 0.6
        } else {
            self.menuButton!.setImage(menuImgOff, forState: UIControlState.Normal)
            self.gridView!.alpha = 0.25
        }

        // Toggle estimotes draggable or not
        for estimote:EstimoteView in self.iBeacons {
            estimote.userInteractionEnabled = !estimote.userInteractionEnabled
            estimote.coordinateLabel.hidden = !estimote.coordinateLabel.hidden
        }
    }
    
    
    func scanButtonClicked(sender: UIButton!) {
        println("scanButtonClicked")
        
        // Change 1) color of button 2) enable/disable beacon manager
        if self.scanMode {
            self.scanButton!.setImage(scanImgOff, forState: UIControlState.Normal)
            self.beaconManager!.stop()
            self.beaconManager!.delegate = nil
        } else {
            self.scanButton!.setImage(scanImgOn, forState: UIControlState.Normal)
            self.beaconManager!.start()
            self.beaconManager!.delegate = self
        }
        
        // Toggle scan mode
        self.scanMode = !self.scanMode
    }
    
    // View Helpers
    
    func createBeaconView(#image: UIImage, coordinates: CGPoint, major: String, minor:String) -> EstimoteView {
        let scaleFactor: Double = 3.0
        let step: CGFloat = CGFloat(self.view.frame.size.width) / CGFloat(self.numberColumns)
        let rect: CGRect = CGRectMake(coordinates.x, coordinates.y, CGFloat(200.0/scaleFactor), CGFloat(340.0/scaleFactor))
        let beaconView: EstimoteView = EstimoteView(frame: rect, image: image, step: step, major: major, minor: minor)
        return beaconView
    }

    func makeMenuButton(#image: UIImage, left: Bool) -> UIButton {
        let menuWidth: CGFloat = 150/3;
        let menuHeight: CGFloat = 133/3;
        let menuPadding: CGFloat = 10;

        let button: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        if (left) {
            button.frame = CGRectMake( menuPadding , self.view.frame.size.height - menuHeight - menuPadding, menuWidth, menuHeight);
        } else {
            button.frame = CGRectMake(self.view.frame.size.width - menuWidth - menuPadding , self.view.frame.size.height - menuHeight - menuPadding, menuWidth, menuHeight);
        }
        button.setImage(image, forState: UIControlState.Normal)
        
        return button;
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

