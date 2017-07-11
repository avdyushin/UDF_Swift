//
//  ViewController.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 29/06/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import ReSwift

enum AppActions: Action {
    case get, set(String)
}

struct AppState: StateType {
    var string: String = "Initial"
}

struct AppReducer {
    static func reduce(action: Action, state: AppState?) -> AppState {
        guard let action = action as? AppActions else {
            return AppState()
        }
        print("reduce me: \(action)")
        var state = state ?? AppState()
        switch action {
        case .get:
            print("GET")
        case .set(let string):
            state.string = string
        }
        return state
    }
}

class ViewController: UIViewController {

    let appStore = Store<AppState>(reducer: AppReducer.reduce, state: AppState())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appStore.subscribe(self)

        appStore.dispatch(AppActions.get)
        appStore.dispatch(AppActions.set("foo"))
        appStore.dispatch(AppActions.get)
    }

    deinit {
        appStore.unsubscribe(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    func newState(state: AppState) {
        print("Has new state: \(state)")
    }
}
