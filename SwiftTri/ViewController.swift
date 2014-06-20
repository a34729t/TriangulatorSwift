//
//  ViewController.swift
//  SwiftTri
//
//  Created by Nicolas Flacco on 6/18/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

// WARNING: Cannot use Images.xcassets with Swift on iOS 7 with XCode Beta (WTF guys?). As a workaround,
// use absolute path as shown here: http://stackoverflow.com/questions/24069479/swift-playgrounds-with-uiimage

import UIKit

class ViewController: UIViewController {
    // global config?
    let numberColumns: Int = 10
    
    // general properties
    var beaconManager: BeaconManager?
    var editMode: Bool = false
    var scanMode: Bool = false
    
    // iBeacons
    var blueEstimote: EstimoteView!
    var greenEstimote: EstimoteView!
    var purpleEstimote: EstimoteView!
    var iBeacons: EstimoteView[] = []

    // UI
    var gridView: GridView?
    var markerView: UIImageView?
    var menuButton: UIButton?
    var scanButton: UIButton?


    // TODO: These need to be MENU_IMG_OFF/MENU_IMG_ON
    let backgroundImage = UIImage(contentsOfFile: "/Users/nflacco/Projects/ios/TriangulatorSwift/SwiftTri/Images.xcassets/background/sandycay.imageset/03478_sandycay_640x1136@2x.png")
    let menuIconImage = UIImage(contentsOfFile: "/Users/nflacco/Projects/ios/TriangulatorSwift/SwiftTri/Images.xcassets/icons/menuIcon.imageset/delta.png")
    let scanIconImage = UIImage(contentsOfFile: "/Users/nflacco/Projects/ios/TriangulatorSwift/SwiftTri/Images.xcassets/icons/scanIcon.imageset/scan.png")
    let locationIconImage = UIImage(contentsOfFile: "/Users/nflacco/Projects/ios/TriangulatorSwift/SwiftTri/Images.xcassets/icons/locationIcon.imageset/location_marker.png")

    // Beacon Images
    let beaconBlue = UIImage(contentsOfFile: "/Users/nflacco/Projects/ios/TriangulatorSwift/SwiftTri/Images.xcassets/beacons/beaconBlue.imageset/beacon_blue.png")
    let beaconGreen = UIImage(contentsOfFile: "/Users/nflacco/Projects/ios/TriangulatorSwift/SwiftTri/Images.xcassets/beacons/beaconGreen.imageset/beacon_green.png")
    let beaconPurple = UIImage(contentsOfFile: "/Users/nflacco/Projects/ios/TriangulatorSwift/SwiftTri/Images.xcassets/beacons/beaconPurple.imageset/beacon_purple.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.beaconManager = sharedBeaconManager
//        if !self.beaconManager.locationServicesEnabled() // TODO

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
        self.blueEstimote = self.createBeaconView(image: beaconGreen,
            coordinates:point1,
            major:BEACON_GREEN_MAJOR,
            minor:BEACON_GREEN_MINOR);
        self.blueEstimote = self.createBeaconView(image: beaconBlue,
            coordinates:point2,
            major:BEACON_BLUE_MAJOR,
            minor:BEACON_BLUE_MINOR);

        self.iBeacons = [self.blueEstimote, self.greenEstimote, self.purpleEstimote];
//        self.iBeacons += self.blueEstimote
//        self.iBeacons += self.greenEstimote
//        self.iBeacons += self.purpleEstimote
        for estimote: EstimoteView in self.iBeacons {
            // NOTE: These settings don't seem to work when set in view initializer
            estimote.userInteractionEnabled = false
            estimote.coordinateLabel.hidden = true
            self.view.addSubview(estimote)
        }



        // Make menu button (detla)
        let menuButton: UIButton = self.makeMenuButton(image: menuIconImage, left:true)
        menuButton.addTarget(self, action: "menuButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(menuButton)
        self.menuButton = menuButton
        
        // Make scan button (antenna)
        let scanButton: UIButton = self.makeMenuButton(image: scanIconImage, left:false)
        scanButton.addTarget(self, action: "scanButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(scanButton)
        self.scanButton = scanButton
        
        // Make location marker

    }

    // BeaconManager Delegate Methods
    
    // Button Delegates
    
    func menuButtonClicked(sender: UIButton!) {
        println("menuButtonClicked")
        // TODO
    }
    
    func scanButtonClicked(sender: UIButton!) {
        println("scanButtonClicked")
        // TODO
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
        let menuWidth: CGFloat = 150/4;
        let menuHeight: CGFloat = 133/4;
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

