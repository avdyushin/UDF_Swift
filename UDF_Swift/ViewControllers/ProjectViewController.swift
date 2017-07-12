//
//  ProjectViewController.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

class ProjectViewController: UITableViewController {

    var project: Project! {
        didSet {
            self.title = project.title
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        projectsStore.subscribe(self) { state in
            state.select { currentState in
                if let project: Project = currentState.navigationState.getRouteSpecificState(currentState.navigationState.route) {
                    self.project = project
                }
                return currentState
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        projectsStore.unsubscribe(self)

        if projectsStore.state.navigationState.route == [
            RouteIdentifiers.HomeViewController.rawValue,
            RouteIdentifiers.ProjectViewController.rawValue] {

            projectsStore.dispatch(SetRouteAction([RouteIdentifiers.HomeViewController.rawValue]))
        }
    }

    @IBAction func onAddTapped(_ sender: Any) {
        let routes: [RouteElementIdentifier] = [
            RouteIdentifiers.HomeViewController.rawValue,
            RouteIdentifiers.ProjectViewController.rawValue,
            RouteIdentifiers.AddItemViewController.rawValue
        ]
        let setDataAction = SetRouteSpecificData(route: routes, data: ProjectItemPair(project: project, item: Item()))
        projectsStore.dispatch(setDataAction)
        projectsStore.dispatch(SetRouteAction(routes))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = project.items[indexPath.row]
        cell.textLabel?.text = item.amount.description
        cell.detailTextLabel?.text = item.timestamp.description
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let item = self.project.items[indexPath.row]
            let action = ItemActions.delete(item)
            projectsStore.dispatch(action)
        }
        let updateAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let item = self.project.items[indexPath.row]
            let routes: [RouteElementIdentifier] = [
                RouteIdentifiers.HomeViewController.rawValue,
                RouteIdentifiers.ProjectViewController.rawValue,
                RouteIdentifiers.AddItemViewController.rawValue
            ]
            let setDataAction = SetRouteSpecificData(route: routes, data: ProjectItemPair(project: self.project, item: item))
            projectsStore.dispatch(setDataAction)
            projectsStore.dispatch(SetRouteAction(routes))
        }
        return [updateAction, deleteAction]
    }

}

extension ProjectViewController: StoreSubscriber {
    func newState(state: MainState) {
        self.tableView.reloadData()
    }
}
