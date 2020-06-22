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

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpAppearance()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.backgroundColor = UIColor.white
        let stepper = Stepper()
        self.stepper = stepper
        let navigationController = stepper.navigationController
        window.rootViewController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        let viewController = Step1ViewController()
        navigationController.pushViewController(viewController, animated: false)
        window.makeKeyAndVisible()
        return true
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
