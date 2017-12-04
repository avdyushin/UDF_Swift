//
//  HomeViewController.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import RealmSwift
import ReSwift
import ReSwiftRouter

class HomeViewController: UITableViewController {

    fileprivate var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 72
        tableView.rowHeight = UITableViewAutomaticDimension

        notificationToken = projectsStore.state.projects.observe { changes in
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                self.tableView.reloadRows(at: modifications.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                self.tableView.deleteRows(at: deletions.map {IndexPath(row: $0, section: 0)}, with: .automatic)
                self.tableView.endUpdates()
            default:
                ()
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    deinit {
        notificationToken?.invalidate()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectViewCell
        cell.project = projectsStore.state.projects[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let project = projectsStore.state.projects[indexPath.row]
            let action = ProjectActions.delete(project)
            projectsStore.dispatch(action)
            tableView.isEditing = false
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
            tableView.isEditing = false
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
