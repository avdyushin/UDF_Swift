//
//  Project.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import RealmSwift

class Project: Object {

    enum Frequency: Int, CustomStringConvertible {
        case daily, monthly, yearly
        static var all = [Frequency.daily, Frequency.monthly, Frequency.yearly]
        var description: String {
            switch self {
            case .daily:
                return "Daily"
            case .monthly:
                return "Monthly"
            case .yearly:
                return "Yearly"
            }
        }
    }

    private var _frequency = Frequency.daily
    var frequency: Frequency {
        get {
            return Frequency(rawValue: frequencyRaw) ?? .daily
        }
        set {
            _frequency = newValue
            frequencyRaw = _frequency.rawValue
        }
    }

    private dynamic var frequencyRaw = 0
    dynamic var id = UUID().uuidString
    dynamic var title = ""
    dynamic var units = ""
    let items = List<Item>()

}
