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
import RealmSwift

struct ProjectReducer {
    static func reduce(action: Action, state: MainState?) -> MainState {
        let navigationState = NavigationReducer.handleAction(action, state: state?.navigationState)
        let realm = try! Realm()

        switch action {
        case let action as CreateProject:
            let project = Project()
            project.title = action.title
            project.frequency = action.frequency
            project.units = action.units

            try! realm.write {
                realm.add(project)
            }
        case let action as DeleteProject:
            try! realm.write {
                realm.delete(action.project)
            }
        default:
            ()
        }

        return MainState(navigationState: navigationState)
    }
}
