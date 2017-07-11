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
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
    }
}

extension HomeViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = MainState
    func newState(state: MainState) {
        self.tableView.reloadData()
    }
}
