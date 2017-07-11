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
        let route: [RouteElementIdentifier] = [
            RouteIdentifiers.HomeViewController.rawValue,
            RouteIdentifiers.AddProjectViewController.rawValue
        ]
        let action = ReSwiftRouter.SetRouteAction(route)
        projectsStore.dispatch(action)
//        let action = CreateProject(route: [""], title: "Demo", frequency: .daily, units: "€")
//        projectsStore.dispatch(action)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectsStore.state.projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
}

extension HomeViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = MainState
    func newState(state: MainState) {
        self.tableView.reloadData()
    }
}
