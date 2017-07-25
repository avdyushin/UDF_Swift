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
            return [String]()
        }

        return Array(Set(project.items.value(forKeyPath: "sectionKey") as! [String]))
    }

    var project: Project? {
        didSet {

            if let project = project {
                self.title = "\(project.frequency) \(project.title)".uppercased()
            }

            notificationToken = project?.items.addNotificationBlock { changes in
                switch changes {
                case .initial:
                    self.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    let inserted = insertions.flatMap { index -> (IndexPath, Int)? in
                        guard let item = self.project?.items[index] else {
                            return nil
                        }
                        let grouped = self.project?.items.filter("sectionKey == %@", item.sectionKey)
                        if let row = grouped?.index(of: item),
                           let section = self.sectionNames.index(of: item.sectionKey),
                           let count = grouped?.count {
                            return (IndexPath(row: row, section: section), count)
                        }
                        return nil
                    }
                    print(deletions, inserted, modifications)
                    
                    if inserted.count > 0 {
                        self.tableView.beginUpdates()
                    }

                    inserted.forEach { (indexPath, sectionsCount) in
                        if sectionsCount == 1 {
                            self.tableView.insertSections([indexPath.section], with: .automatic)
                        } else {
                            self.tableView.insertRows(at: [indexPath], with: .automatic)
                        }
                    }

                    if inserted.count > 0 || deletions.count > 0 || modifications.count > 0 {
                        self.tableView.endUpdates()
                    }
                default:
                    ()
                }
            }

        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        projectsStore.subscribe(self) { state in
            state.select { currentState in
                if let project: Project = currentState.navigationState.getRouteSpecificState(currentState.navigationState.route) {
                    if self.project?.id != project.id {
                        self.project = project
                    }
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

    deinit {
        notificationToken?.stop()
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
        let setDataAction = SetRouteSpecificData(route: routes, data: ProjectItemPair(project: project, item: Item()))
        projectsStore.dispatch(setDataAction)
        projectsStore.dispatch(SetRouteAction(routes))
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
        let setDataAction = SetRouteSpecificData(route: routes, data: ProjectItemPair(project: project, item: item))
        projectsStore.dispatch(setDataAction)
        projectsStore.dispatch(SetRouteAction(routes))

        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
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

//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row % 2 == 0 {
//            cell.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
//        } else {
//            cell.contentView.backgroundColor = UIColor(white: 0.9, alpha: 1)
//        }
//    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let grouped = self.project?.items.filter("sectionKey == %@", self.sectionNames[indexPath.section])
            guard let item = grouped?[indexPath.row],
                  let count = grouped?.count else {
                return
            }

            let action = ItemActions.delete(item)
            projectsStore.dispatch(action)
            self.tableView.beginUpdates()
            if count == 1 {
                self.tableView.deleteSections([indexPath.section], with: .automatic)
            } else {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            tableView.isEditing = false
        }
        let updateAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.editItem(at: indexPath)
            tableView.isEditing = false
        }
        return [updateAction, deleteAction]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.editItem(at: indexPath)
    }
}

extension ProjectViewController: StoreSubscriber {
    func newState(state: MainState) { }
}
