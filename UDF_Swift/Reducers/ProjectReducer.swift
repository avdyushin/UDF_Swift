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

        guard let action = action as? ProjectActions else {
            return MainState(navigationState: navigationState)
        }

        let realm = try! Realm()
        switch action {
        case .update(let project, let title, let frequence, let units):
            try! realm.write {
                realm.add(project)
                project.title = title
                project.frequency = frequence
                project.units = units
            }
        case .delete(let project):
            try! realm.write {
                realm.delete(project)
            }
        }
        return MainState(navigationState: navigationState)
    }
}
