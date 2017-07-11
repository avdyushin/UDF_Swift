//
//  MainState.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

struct MainState: StateType, HasNavigationState {
    var navigationState: NavigationState
    var projects: [Project]

    static var `default` = MainState(navigationState: NavigationState(), projects: [])
}
