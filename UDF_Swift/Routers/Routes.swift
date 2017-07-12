//
//  Routes.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import ReSwiftRouter

enum RouteIdentifiers: RouteElementIdentifier {
    case HomeViewController
    case AddProjectViewController
    case ProjectViewController
    case AddItemViewController
}

struct AddProjectRoutable: Routable {}
struct AddItemRoutable: Routable {}

struct ProjectRoutable: Routable {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: UIViewController

    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        let viewController = storyboard.instantiateViewController(withIdentifier: routeElementIdentifier)
        let nav = UINavigationController(rootViewController: viewController)
        self.viewController.present(nav, animated: animated, completion: completionHandler)
        return AddItemRoutable()
    }

    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) {
        print("_pop \(routeElementIdentifier)")
        completionHandler()
    }
    func changeRouteSegment(_ from: RouteElementIdentifier, to: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        print("_change \(from) to \(to)")
        completionHandler()
        return self
    }
}

struct HomeViewRoutable: Routable {
    let window: UIWindow

    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    @discardableResult func setToViewController(_ viewController: UIViewController) -> Routable {
        let nav = UINavigationController(rootViewController: viewController)
        self.window.rootViewController = nav
        return self
    }

    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        let viewController = storyboard.instantiateViewController(withIdentifier: routeElementIdentifier)
        switch routeElementIdentifier {
        case RouteIdentifiers.HomeViewController.rawValue:
            completionHandler()
            return setToViewController(viewController)
        case RouteIdentifiers.AddProjectViewController.rawValue:
            let nav = UINavigationController(rootViewController: viewController)
            self.window.rootViewController?.present(nav, animated: true, completion: completionHandler)
            return AddProjectRoutable()
        case RouteIdentifiers.ProjectViewController.rawValue:
            if let nav = self.window.rootViewController as? UINavigationController {
                nav.pushViewController(viewController, animated: animated)
            }
            completionHandler()
            return ProjectRoutable(viewController: viewController)
        default: ()
        }
        fatalError("Push route `\(routeElementIdentifier)` not found!")
    }

    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) {
        switch routeElementIdentifier {
        case RouteIdentifiers.AddProjectViewController.rawValue,
             RouteIdentifiers.ProjectViewController.rawValue,
             RouteIdentifiers.AddItemViewController.rawValue:
            completionHandler()
            return
        default: ()
        }
        fatalError("Pop route `\(routeElementIdentifier)` not found!")
    }

    func changeRouteSegment(_ from: RouteElementIdentifier, to: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        print("Change \(from) to \(to)")
        let viewController = storyboard.instantiateViewController(withIdentifier: to)
        return setToViewController(viewController)
    }
}
