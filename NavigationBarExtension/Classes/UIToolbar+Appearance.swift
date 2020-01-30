//
//  UIToolbar+Appearance.swift
//  ADNavigationBarExtension
//
//  Created by Samuel Gallet on 29/01/2020.
//

import Foundation

extension UIToolbar {

    func ad_setValuesFromAppearance() {
        tintColor = UINavigationBar
            .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
            .tintColor
        barTintColor = UINavigationBar
            .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
            .barTintColor
        isTranslucent = ExtensibleNavigationBarNavigationController.ad_isTranslucent
        if #available(iOS 13, *) {
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
        } else {
            backgroundColor = UINavigationBar
                .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
                .backgroundColor
        }
    }
}
