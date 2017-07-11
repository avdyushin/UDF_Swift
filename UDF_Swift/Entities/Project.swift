//
//  Project.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit

struct Project {

    enum Frequency {
        case daily, monthly, yearly
    }

    var title: String
    var frequency: Frequency
    var units: String
    var items: [Item]
}
