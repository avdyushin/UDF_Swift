//
//  AddProjectViewController.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

class AddProjectViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!

    private let frequencies = Project.Frequency.all
    private var frequencyIndex = 0

    private var project: Project? = nil {
        didSet {
            if let project = project {
                titleLabel.text = project.title
                frequencyIndex = project.frequency.rawValue
                frequencyLabel.text = frequencies[frequencyIndex].description
                unitsLabel.text = project.units
            } else {
                titleLabel.text = ""
                frequencyLabel.text = frequencies[frequencyIndex].description
                unitsLabel.text = ""
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        projectsStore.subscribe(self) { state in
            state.select { currentState in
                self.project = currentState.navigationState.getRouteSpecificState(currentState.navigationState.route)
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
        guard let title = titleLabel.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Title shouldn't be empty", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let frequency = frequencies[frequencyIndex]

        if let project = project {
            let action = ProjectActions.update(project, title, frequency, unitsLabel.text ?? "")
            projectsStore.dispatch(action)
            routeBack()
        }
    }

    func routeBack() {
        dismiss(animated: true, completion: nil)
        if projectsStore.state.navigationState.route == [
            RouteIdentifiers.HomeViewController.rawValue,
            RouteIdentifiers.AddProjectViewController.rawValue] {

            projectsStore.dispatch(SetRouteAction([RouteIdentifiers.HomeViewController.rawValue]))
        }
    }

    func inputAlert(title: String, value: String? = nil, completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = title
            textField.text = value
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            let textField = alert.textFields?[0]
            DispatchQueue.main.async {
                completion(textField?.text)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completion(nil)
        })
        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            inputAlert(title: "Title", value: project?.title) { text in
                if let title = text {
                    self.titleLabel.text = title
                    self.tableView.reloadData()
                }
            }
        case 1:
            frequencyIndex = (frequencyIndex + 1) % frequencies.count
            frequencyLabel.text = frequencies[frequencyIndex].description
            tableView.reloadData()
        case 2:
            inputAlert(title: "Units", value: project?.units) { text in
                if let units = text {
                    self.unitsLabel.text = units
                    self.tableView.reloadData()
                }
            }
        default:
            ()
        }
    }
}

extension AddProjectViewController: StoreSubscriber {
    func newState(state: MainState) {

    }
}
