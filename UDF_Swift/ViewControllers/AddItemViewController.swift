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
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var pickerView: UIView!

    private var project: Project!
    private var item: Item! {
        didSet {
            if let amount = item?.amount, amount > 0 {
                amountTextField.text = amount.description
                self.title = "EDIT ITEM"
            } else {
                amountTextField.text = nil
                self.title = "NEW ITEM"
            }
            datePicker.date = item?.timestamp ?? Date()
        }
    }

    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.YYYY"
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dateTextField.inputView = pickerView
        onDateChanged(datePicker)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        amountTextField.becomeFirstResponder()

        projectsStore.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        amountTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        projectsStore.unsubscribe(self)
    }

    @IBAction func onCancelTapped(_ sender: Any) {
        routeBack()
    }

    @IBAction func onSaveTapped(_ sender: Any) {
        projectsStore.dispatch(ItemActions.update(
            item,
            project: project,
            amount: Double(amountTextField.text ?? "0") ?? 0,
            timestamp: datePicker.date,
            notes: ""
        ))
        routeBack()
    }

    @IBAction func onDateChanged(_ sender: Any) {
        dateTextField.text = dateFormatter.string(from: datePicker.date)
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
        if let projectItem: ProjectItemPair? = state.navigationState.getRouteSpecificState(state.navigationState.route) {
            if let project = projectItem?.project {
                self.project = project
            }
            if let item = projectItem?.item {
                self.item = item
            }
        }
    }
}
