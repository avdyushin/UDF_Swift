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
}

struct AddProjectRoutable: Routable { }

struct HomeViewRoutable: Routable {
    let window: UIWindow

    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    @discardableResult func setToMain() -> Routable {
        let vc = storyboard.instantiateViewController(withIdentifier: RouteIdentifiers.HomeViewController.rawValue)
        let nav = UINavigationController(rootViewController: vc)
        self.window.rootViewController = nav
        return self
    }

    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        switch routeElementIdentifier {
        case RouteIdentifiers.HomeViewController.rawValue:
            completionHandler()
            return setToMain()
        case RouteIdentifiers.AddProjectViewController.rawValue:
            let vc = storyboard.instantiateViewController(withIdentifier: routeElementIdentifier)
            if let nav = self.window.rootViewController as? UINavigationController {
                completionHandler()
                nav.pushViewController(vc, animated: animated)
                return AddProjectRoutable()
            }
        default: ()
        }
        fatalError("Push route `\(routeElementIdentifier)` not found!")
    }

    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) {
        switch routeElementIdentifier {
        case RouteIdentifiers.AddProjectViewController.rawValue:
            completionHandler()
            return
        default: ()
        }
        fatalError("Pop route `\(routeElementIdentifier)` not found!")
    }

    func changeRouteSegment(_ from: RouteElementIdentifier, to: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        print("Change \(from) to \(to)")
        return setToMain()
    }
}
