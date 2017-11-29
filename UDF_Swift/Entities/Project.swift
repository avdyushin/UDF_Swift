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
        case daily = 0, monthly, yearly
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

    var totalAmount: Double {
        return items.reduce(0.0) { (total, item) -> Double in
            return total + item.amount
        }
    }

    var totalAmountString: String {
        return amountFormatter.string(from: NSNumber(value: totalAmount)) ?? totalAmount.description
    }

    var amountFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.positiveFormat = "¤ #,##0.##"
        nf.negativeFormat = "¤ -#,##0.##"
        nf.currencySymbol = self.units
        nf.numberStyle = .currency
        return nf
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

    @objc private dynamic var frequencyRaw = 0
    @objc private dynamic var order = 0
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var units = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()
    let items = List<Item>()

}
