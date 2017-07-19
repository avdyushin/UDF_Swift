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

    dynamic var id = UUID().uuidString
    dynamic var timestamp = Date()
    dynamic var amount = -1.0
    dynamic var comment: String?
    
}
