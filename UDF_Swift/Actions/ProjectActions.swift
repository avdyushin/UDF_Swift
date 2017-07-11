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

struct CreateProject: Action {
    let title: String
    let frequency: Project.Frequency
    let units: String
}

struct DeleteProject: Action {
    let project: Project
}
