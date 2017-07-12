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
    case update(Project, String, Project.Frequency, String)
    case delete(Project)
}

enum ItemActions: Action {
    case update(Project, Item, Double, Date, String?)
    case delete(Item)
}
