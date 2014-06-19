//
//  ViewController.swift
//  SwiftTri
//
//  Created by Nicolas Flacco on 6/18/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // global config?
    let numberColumns: Int = 10
    // TODO imgs

//    var editMode: Bool
//    var scanMode: Bool
//    var panRecognizer: UIPanGestureRecognizer
//    var beaconManager: BeaconManager

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        beaconManager = sharedBeaconManager
//        if !beaconManager.locationServicesEnabled()

        // Set background image
        let backgroundImageView: UIImageView = UIImageView(image: UIImage(contentsOfFile: "sandyCay"))
        self.view.addSubview(backgroundImageView)
        
        // Draw grid
        let gridView: GridView = GridView(frame: self.view.frame, columns: numberColumns)
        gridView.alpha = 0.25;
        self.view.addSubview(gridView);
        
        // Create iBeacons

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

