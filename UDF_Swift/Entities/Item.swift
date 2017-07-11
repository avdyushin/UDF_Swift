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

    dynamic var id = UUID().uuidString
    dynamic var timestamp = Date()
    dynamic var amount = 0.0
    dynamic var comment: String?
    
}
