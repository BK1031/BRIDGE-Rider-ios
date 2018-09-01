//
//  Initialization.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/11/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import MaterialComponents

var appVersion = 1.1

let terms = "Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. Terms and Conditions of BRIDGE. Here is the terms and condtions of bridge. I think that makign sure the key to bkah blah d fbkalfrbeiuaa faofhoeaojofp ajfeoopf nd oeif sneojosf ojfsemfose fsoefm fsfsoo. "

var tempPassword = ""

var name = ""
var email = ""
var phone = ""
var userID = ""
var isStudent = false
var profilePic: UIImage = #imageLiteral(resourceName: "profile")

var addressLine1 = ""
var addressCity = ""
var addressState = ""
var addressZIP = ""
var addressFull = ""

var homeLat = 0.0
var homeLong = 0.0

var accountBalance = 0.0

var school = ""
var schoolLat = 0.0
var schoolLong = 0.0

var startTime = ""
var midTime = ""
var endTime = ""
var startLat = 0.0
var startLong = 0.0
var endLat = 0.0
var endLong = 0.0

var driverID = ""
var driverName = ""

var destination = ""

var schoolsList = ["BASIS Independent Silicon Valley", "Bellarmine College Preparatory", "Harker’s Upper School", "Valley Christian High School"]

var selectedRide = ""

let bridgeMapStyle = try! GMSMapStyle.init(contentsOfFileURL: Bundle.main.url(forResource: "BridgeGMapsStyle", withExtension: "json")!)
