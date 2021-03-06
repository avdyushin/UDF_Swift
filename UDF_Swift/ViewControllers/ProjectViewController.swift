//
//  ProjectViewController.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import RealmSwift
import ReSwift
import ReSwiftRouter

class ProjectViewController: UITableViewController {

    fileprivate var notificationToken: NotificationToken?

    var sectionNames: [String] {
        guard let project = project else {
            return []
        }

        return Array(Set(project.items.map { return $0.sectionKey }))
    }

    var project: Project? {
        didSet {
            if let project = project {
                self.title = "\(project.frequency) \(project.title) in \(project.units)".uppercased()
                notificationToken = project.items.observe { [weak self] changes in
                    self?.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.projectsStore.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if AppDelegate.projectsStore.state.navigationState.route == [
            RouteIdentifiers.HomeViewController.rawValue,
            RouteIdentifiers.ProjectViewController.rawValue] {

            AppDelegate.projectsStore.dispatch(SetRouteAction([RouteIdentifiers.HomeViewController.rawValue]))
        }
    }

    deinit {
        notificationToken?.invalidate()
        AppDelegate.projectsStore.unsubscribe(self)
    }

    @IBAction func onAddTapped(_ sender: Any) {
        guard let project = self.project else {
            return
        }
        let routes: [RouteElementIdentifier] = [
            RouteIdentifiers.HomeViewController.rawValue,
            RouteIdentifiers.ProjectViewController.rawValue,
            RouteIdentifiers.AddItemViewController.rawValue
        ]
        let setDataAction = SetRouteSpecificData(route: routes, data: RouteData.project(project))
        AppDelegate.projectsStore.dispatch(setDataAction)
        AppDelegate.projectsStore.dispatch(SetRouteAction(routes))
    }

    func editItem(at indexPath: IndexPath) {
        guard let project = self.project else {
            return
        }
        let item = project.items.filter("sectionKey == %@", sectionNames[indexPath.section])[indexPath.row]
        let routes: [RouteElementIdentifier] = [
            RouteIdentifiers.HomeViewController.rawValue,
            RouteIdentifiers.ProjectViewController.rawValue,
            RouteIdentifiers.AddItemViewController.rawValue
        ]
        let setDataAction = SetRouteSpecificData(route: routes, data: RouteData.item(item, parent: project))
        AppDelegate.projectsStore.dispatch(setDataAction)
        AppDelegate.projectsStore.dispatch(SetRouteAction(routes))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project?.items.filter("sectionKey == %@", sectionNames[section]).count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemViewCell
        guard let item = project?.items.filter("sectionKey == %@", sectionNames[indexPath.section])[indexPath.row] else {
            return cell
        }
        cell.numberFormatter = project?.amountFormatter
        cell.item = item
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let grouped = self.project?.items.filter("sectionKey == %@", self.sectionNames[indexPath.section])
            guard let project = self.project, let item = grouped?[indexPath.row] else {
                return
            }

            let action = ItemActions.delete(item, parent: project)
            AppDelegate.projectsStore.dispatch(action)
            tableView.isEditing = false
        }
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.editItem(at: indexPath)
            tableView.isEditing = false
        }
        return [editAction, deleteAction]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.editItem(at: indexPath)
    }
}

extension ProjectViewController: StoreSubscriber {
    func newState(state: MainState) {
        if let project: Project = state.navigationState.getRouteSpecificState(state.navigationState.route) {
            self.project = project
        }
    }
}
