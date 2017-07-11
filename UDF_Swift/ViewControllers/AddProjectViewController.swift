//
//  AddProjectViewController.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import ReSwiftRouter

class AddProjectViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!

    private let frequencies = Project.Frequency.all
    private var frequencyIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = ""
        frequencyLabel.text = frequencies[frequencyIndex].description
        unitsLabel.text = ""
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func onCancelTapped(_ sender: Any) {
        routeBack()
    }

    @IBAction func onSaveTapped(_ sender: Any) {
        guard let title = titleLabel.text,
              let units = unitsLabel.text else {
            return
        }
        let frequency = frequencies[frequencyIndex]
        let action = CreateProject(title: title, frequency: frequency, units: units)
        projectsStore.dispatch(action)
        routeBack()
    }

    func routeBack() {
        dismiss(animated: true, completion: nil)
        if projectsStore.state.navigationState.route == [
            RouteIdentifiers.HomeViewController.rawValue,
            RouteIdentifiers.AddProjectViewController.rawValue] {

            projectsStore.dispatch(SetRouteAction([RouteIdentifiers.HomeViewController.rawValue]))
        }
    }

    func inputAlert(title: String, completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = title
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
            inputAlert(title: "Title") { text in
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
            inputAlert(title: "Units") { text in
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
