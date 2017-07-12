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
import RealmSwift

class MainState: NSObject, StateType, HasNavigationState {
    var navigationState: NavigationState
    var projects: Results<Project>
    let realm = try! Realm()

    init(navigationState: NavigationState = NavigationState()) {
        self.projects = realm.objects(Project.self).sorted(byKeyPath: "updatedAt", ascending: false)
        self.navigationState = navigationState
    }

    static var `default` = MainState()
}
