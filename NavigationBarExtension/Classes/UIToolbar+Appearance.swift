//
//  UIToolbar+Appearance.swift
//  ADNavigationBarExtension
//
//  Created by Samuel Gallet on 29/01/2020.
//

import UIKit

extension UIToolbar {

    func ad_setValuesFromAppearance() {
        tintColor = UINavigationBar
            .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
            .tintColor
        barTintColor = UINavigationBar
            .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
            .barTintColor
        let compactNavigationBarAppearance = UINavigationBar
            .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
            .compactAppearance
        compactAppearance = compactNavigationBarAppearance.map { UIToolbarAppearance(barAppearance: $0) }
        let standardNavigationBarAppearance: UINavigationBarAppearance? = UINavigationBar
            .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
            .standardAppearance
        if let appearance = standardNavigationBarAppearance {
            standardAppearance = UIToolbarAppearance(barAppearance: appearance)
        }
    }
}
