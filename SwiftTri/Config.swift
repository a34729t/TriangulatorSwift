//
//  Config.swift
//  SwiftTri
//
//  Created by Nicolas Flacco on 6/18/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import Foundation

// General search criteria for beacons that are broadcasting
let BEACON_SERVICE_NAME = "estimote"
let BEACON_PROXIMITY_UUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")

// Beacons are hardcoded into our app so we can easily filter for them in a noisy environment
let BEACON_PURPLE_MAJOR = "60463"
let BEACON_PURPLE_MINOR = "56367"
let BEACON_GREEN_MAJOR = "544"
let BEACON_GREEN_MINOR = "50962"
let BEACON_BLUE_MAJOR = "23680"
let BEACON_BLUE_MINOR = "7349"