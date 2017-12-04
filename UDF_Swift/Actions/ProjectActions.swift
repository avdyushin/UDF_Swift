//
//  ProjectActions.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRouter

enum ProjectActions: Action {
    case update(Project, title: String, frequency: Project.Frequency, units: String)
    case delete(Project)
}

enum ItemActions: Action {
    case update(Item, project: Project, amount: Double, timestamp: Date, notes: String?)
    case delete(Item)
}

struct ProjectItemPair {
    let project: Project
    let item: Item
}
