//
//  AddItemViewController.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 12/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

class AddItemViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    private var project: Project!
    private var item: Item! {
        didSet {
            amountTextField.text = item?.amount.description
            datePicker.date = item?.timestamp ?? Date()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        projectsStore.subscribe(self) { state in
            state.select { currentState in
                if let projectItem: ProjectItemPair? = currentState.navigationState.getRouteSpecificState(currentState.navigationState.route) {
                    if let project = projectItem?.project {
                        self.project = project
                    }
                    if let item = projectItem?.item {
                        self.item = item
                    }
                }
                return currentState
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        projectsStore.unsubscribe(self)
    }

    @IBAction func onCancelTapped(_ sender: Any) {
        routeBack()
    }

    @IBAction func onSaveTapped(_ sender: Any) {
        let action = ItemActions.update(project, item, Double(amountTextField.text ?? "0") ?? 0, datePicker.date, "")
        projectsStore.dispatch(action)
        routeBack()
    }

    func routeBack() {
        dismiss(animated: true, completion: nil)
        if projectsStore.state.navigationState.route == [
            RouteIdentifiers.HomeViewController.rawValue,
            RouteIdentifiers.ProjectViewController.rawValue,
            RouteIdentifiers.AddItemViewController.rawValue] {

            projectsStore.dispatch(SetRouteAction([
                RouteIdentifiers.HomeViewController.rawValue,
                RouteIdentifiers.ProjectViewController.rawValue
            ]))
        }
    }

}

extension AddItemViewController: StoreSubscriber {
    func newState(state: MainState) {

    }
}
