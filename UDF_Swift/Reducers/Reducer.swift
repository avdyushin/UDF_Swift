//
//  Reducer.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRouter
import RealmSwift

struct Reducer {
    static func reduce(action: Action, state: MainState?) -> MainState {
        let state = state ?? MainState()
        state.navigationState = NavigationReducer.handleAction(action, state: state.navigationState)

        switch action {
        case let action as ProjectActions:
            reduce(action, state: state)
        case let action as ItemActions:
            reduce(action, state: state)
        default:
            ()
        }

        return state
    }

    static func reduce(_ action: ProjectActions, state: MainState) {
        switch action {
        case .create(let title, let frequency, let units):
            try! state.realm.write {
                let project = Project()
                state.realm.add(project)
                project.title = title
                project.frequency = frequency
                project.units = units
            }
        case .update(let project, let newTitle, let newFrequence, let newUnits):
            try! state.realm.write {
                project.title = newTitle
                project.frequency = newFrequence
                project.units = newUnits
            }
        case .delete(let project):
            try! state.realm.write {
                state.realm.delete(project)
            }
        }
    }

    static func reduce(_ action: ItemActions, state: MainState) {
        switch action {
        case .create(let project, let amount, let timestamp, let notes):
            try! state.realm.write {
                let item = Item()
                state.realm.add(item)
                item.amount = amount
                item.timestampValue = timestamp
                item.comment = notes
                project.items.append(item)
                project.updatedAt = Date()
            }
        case .update(let item, let project, let newAmount, let newTimestamp, let newNotes):
            try! state.realm.write {
                item.amount = newAmount
                item.timestampValue = newTimestamp
                item.comment = newNotes
                project.updatedAt = Date()
            }
        case .delete(let item):
            try! state.realm.write {
                state.realm.delete(item)
            }
        }
    }
}
