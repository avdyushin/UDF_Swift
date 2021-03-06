//
//  AppDelegate.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 29/06/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let projectsStore = Store<MainState>(reducer: Reducer.reduce, state: MainState.default)

    var window: UIWindow?
    var router: Router<MainState>!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
            }
        ) 
        Realm.Configuration.defaultConfiguration = config

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()

        let mainRouter = HomeViewRouter(window: window!)
        router = Router(store: AppDelegate.projectsStore, rootRoutable: mainRouter) {
            $0.select { $0.navigationState }
        }

        AppDelegate.projectsStore.dispatch(SetRouteAction([RouteIdentifiers.HomeViewController.rawValue]))

        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().backgroundColor = .darkGray
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]

        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
