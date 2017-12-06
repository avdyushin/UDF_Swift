//
//  ProjectActions.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import Foundation
import ReSwift

/// Project actions
enum ProjectActions: Action {
    /// Creates new `Project` with given title, frequency and units
    case create(title: String, frequency: Project.Frequency, units: String)
    /// Updates given `Project` with new title, frequency and units
    case update(Project, newTitle: String, newFrequency: Project.Frequency, newUnits: String)
    /// Deletes given `Project`
    case delete(Project)
}

/// Item actions
enum ItemActions: Action {
    /// Creates new `Item` in parent `Project` with given amount, timestamp and notes
    case create(parent: Project, amount: Double, timestamp: Date, notes: String?)
    /// Updates given `Item` with new amount, timestamp and notes
    /// Parent `Project` is needed to change `updatedAt` date
    case update(Item, parent: Project, newAmount: Double, newTimestamp: Date, newNotes: String?)
    /// Deletes given `Item`
    case delete(Item)
}
