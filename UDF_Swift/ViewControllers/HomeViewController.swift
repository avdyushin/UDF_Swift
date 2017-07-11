//
//  HomeViewController.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        projectsStore.subscribe(self)
    }

    deinit {
        projectsStore.unsubscribe(self)
    }

    @IBAction func onAddTapped(_ sender: Any) {
        let routes: [RouteElementIdentifier] = [
            RouteIdentifiers.HomeViewController.rawValue,
            RouteIdentifiers.AddProjectViewController.rawValue
        ]
        let setDataAction = SetRouteSpecificData(route: routes, data: Project())
        projectsStore.dispatch(setDataAction)
        projectsStore.dispatch(SetRouteAction(routes))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectsStore.state.projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
        let project = projectsStore.state.projects[indexPath.row]
        cell.textLabel?.text = project.title
        cell.detailTextLabel?.text = "\(project.frequency) in \(project.units), items = \(project.items.count)"
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let project = projectsStore.state.projects[indexPath.row]
            let action = ProjectActions.delete(project)
            projectsStore.dispatch(action)
        }
        let updateAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let project = projectsStore.state.projects[indexPath.row]
            let routes: [RouteElementIdentifier] = [
                RouteIdentifiers.HomeViewController.rawValue,
                RouteIdentifiers.AddProjectViewController.rawValue
            ]
            let routeAction = SetRouteAction(routes)
            let setDataAction = SetRouteSpecificData(route: routes, data: project)
            projectsStore.dispatch(setDataAction)
            projectsStore.dispatch(routeAction)
        }
        return [updateAction, deleteAction]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let project = projectsStore.state.projects[indexPath.row]
        let routes: [RouteElementIdentifier] = [
            RouteIdentifiers.HomeViewController.rawValue,
            RouteIdentifiers.ProjectViewController.rawValue
        ]

        let routeAction = SetRouteAction(routes)
        let setDataAction = SetRouteSpecificData(route: routes, data: project)
        projectsStore.dispatch(setDataAction)
        projectsStore.dispatch(routeAction)
    }
}

extension HomeViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = MainState
    func newState(state: MainState) {
        self.tableView.reloadData()
    }
}
