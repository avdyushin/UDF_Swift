//
//  Routes.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 11/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import ReSwiftRouter

/// Route identifiers which are also a storyboard identifiers
enum RouteIdentifiers: RouteElementIdentifier {
    case HomeViewController
    case AddProjectViewController
    case ProjectViewController
    case AddItemViewController
}

/// Data to pass into view controllers during the routing
enum RouteData {
    case project(Project)
    case item(Item, parent: Project)
}

/// Home screen
struct HomeViewRoutable: Routable {
    let window: UIWindow
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    private func setToViewController(_ viewController: UIViewController) -> Routable {
        let nav = UINavigationController(rootViewController: viewController)
        self.window.rootViewController = nav
        return self
    }

    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                          animated: Bool,
                          completionHandler: @escaping RoutingCompletionHandler) -> Routable {

        let viewController = storyboard.instantiateViewController(withIdentifier: routeElementIdentifier)
        switch routeElementIdentifier {
        case RouteIdentifiers.HomeViewController.rawValue:
            completionHandler()
            return setToViewController(viewController)
        case RouteIdentifiers.AddProjectViewController.rawValue:
            let nav = UINavigationController(rootViewController: viewController)
            self.window.rootViewController?.present(nav, animated: true, completion: completionHandler)
            return self
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

    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                         animated: Bool,
                         completionHandler: @escaping RoutingCompletionHandler) {

        switch routeElementIdentifier {
        case RouteIdentifiers.AddProjectViewController.rawValue,
             RouteIdentifiers.AddItemViewController.rawValue:
            self.window.rootViewController?.presentedViewController?.dismiss(animated: true, completion: completionHandler)
            return
        case RouteIdentifiers.ProjectViewController.rawValue:
            completionHandler()
            return
        default: ()
        }

        fatalError("Pop route `\(routeElementIdentifier)` not found!")
    }

    func changeRouteSegment(_ from: RouteElementIdentifier,
                            to: RouteElementIdentifier,
                            animated: Bool,
                            completionHandler: @escaping RoutingCompletionHandler) -> Routable {

        let viewController = storyboard.instantiateViewController(withIdentifier: to)
        return setToViewController(viewController)
    }
}

/// Project details screen
struct ProjectRoutable: Routable {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController: UIViewController

    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                          animated: Bool,
                          completionHandler: @escaping RoutingCompletionHandler) -> Routable {

        let viewController = storyboard.instantiateViewController(withIdentifier: routeElementIdentifier)
        let nav = UINavigationController(rootViewController: viewController)
        self.viewController.present(nav, animated: animated, completion: completionHandler)
        return self
    }

    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                         animated: Bool,
                         completionHandler: @escaping RoutingCompletionHandler) {

        self.viewController.presentedViewController?.dismiss(animated: true, completion: completionHandler)
    }

    func changeRouteSegment(_ from: RouteElementIdentifier,
                            to: RouteElementIdentifier,
                            animated: Bool,
                            completionHandler: @escaping RoutingCompletionHandler) -> Routable {

        completionHandler()
        return self
    }
}
