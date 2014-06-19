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
    var blueEstimote: EstimoteView?
    var greenEstimote: EstimoteView?
    var purpleEstimote: EstimoteView?
    
    // UI
    var gridView: GridView?
    var markerView: UIImageView?
    var menuButton: UIButton?
    var scanButton: UIButton?
    
    // Images (see warning at top of file)
    let backgroundImage = UIImage(contentsOfFile: "/Users/nflacco/Projects/ios/TriangulatorSwift/SwiftTri/Images.xcassets/background/sandycay.imageset/03478_sandycay_640x1136@2x.png")
    let menuIconImage = UIImage(contentsOfFile: "/Users/nflacco/Projects/ios/TriangulatorSwift/SwiftTri/Images.xcassets/icons/menuIcon.imageset/delta.png")
    let scanIconImage = UIImage(contentsOfFile: "/Users/nflacco/Projects/ios/TriangulatorSwift/SwiftTri/Images.xcassets/icons/scanIcon.imageset/scan.png")
    let locationIconImage = UIImage(contentsOfFile: "/Users/nflacco/Projects/ios/TriangulatorSwift/SwiftTri/Images.xcassets/icons/locationIcon.imageset/location_marker.png")

    // TODO: These need to be MENU_IMG_OFF/MENU_IMG_ON
    
    
    
    
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
    
    func createBeaconView(#image: UIImage, coordinates: CGPoint, major: String, minor:String) {
        // TODO
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

