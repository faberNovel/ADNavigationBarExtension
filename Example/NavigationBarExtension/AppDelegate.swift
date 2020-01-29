//
//  AppDelegate.swift
//  NavigationBarExtension
//
//  Created by Samuel Gallet on 01/21/2020.
//  Copyright (c) 2020 Samuel Gallet. All rights reserved.
//

import ADNavigationBarExtension
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var stepper: Stepper?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpAppearance()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.backgroundColor = UIColor.white
        let stepper = Stepper()
        self.stepper = stepper
        let navigationController = stepper.navigationController
        window.rootViewController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        let vc = Step1ViewController()
        navigationController.pushViewController(vc, animated: false)
        window.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // MARK: - Private

    private func setUpAppearance() {
        UINavigationBar
            .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
            .tintColor = UIColor.purple
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            UINavigationBar
                .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
                .standardAppearance = appearance
            UINavigationBar
                .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
                .compactAppearance = appearance
            UINavigationBar
                .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
                .scrollEdgeAppearance = appearance
        } else {
            ExtensibleNavigationBarNavigationController.ad_isTranslucent = false
        }
    }
}

