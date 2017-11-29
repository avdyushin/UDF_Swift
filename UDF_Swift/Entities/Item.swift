//
//  Item.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {

    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.YYYY"
        return df
    }()

    static var keyFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM-YYYY"
        return df
    }()

    var timestampValue: Date = Date() {
        didSet {
            timestamp = timestampValue
            sectionKey = Item.keyFormatter.string(from: timestamp)
        }
    }

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var timestamp = Date()
    @objc dynamic var sectionKey = ""
    @objc dynamic var amount = -1.0
    @objc dynamic var comment: String?

    override static func ignoredProperties() -> [String] {
        return ["timestampValue"]
    }
}
