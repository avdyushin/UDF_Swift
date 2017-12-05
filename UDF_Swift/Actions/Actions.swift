//
//  ProjectActions.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import Foundation
import ReSwift

enum ProjectActions: Action {
    case create(title: String, frequency: Project.Frequency, units: String)
    case update(Project, newTitle: String, newFrequency: Project.Frequency, newUnits: String)
    case delete(Project)
}

enum ItemActions: Action {
    case create(parent: Project, amount: Double, timestamp: Date, notes: String?)
    case update(Item, parent: Project, newAmount: Double, newTimestamp: Date, newNotes: String?)
    case delete(Item)
}
