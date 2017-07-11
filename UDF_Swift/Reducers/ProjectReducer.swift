//
//  ProjectReducer.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRouter

struct ProjectReducer {
    static func reduce(action: Action, state: MainState?) -> MainState {

        let navigationState = NavigationReducer.handleAction(action, state: state?.navigationState)
        var projects = state?.projects ?? []

        if let action = action as? CreateProject {
            print(action.title)
        }

        return MainState(navigationState: navigationState,
                         projects: projects)
    }
}
