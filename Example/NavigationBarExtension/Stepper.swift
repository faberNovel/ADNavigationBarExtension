//
//  Stepper.swift
//  NavigationBarExtension_Example
//
//  Created by Samuel Gallet on 29/01/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import ADNavigationBarExtension
import Foundation
import UIKit

protocol StepperNavigationProvider: ExtensibleNavigationBarInformationProvider {
    var stepTitle: String? { get }
}

extension StepperNavigationProvider {
    var shouldExtendNavigationBar: Bool { return true }
}

class Stepper: NSObject, UINavigationControllerDelegate {
    let navigationController = ExtensibleNavigationBarNavigationController()
    let stepView = NavBarExtensionView()

    override init() {
        super.init()
        navigationController.navigationControllerDelegate = self
        setUp()
    }

    // MARK: - UINavigationControllerDelegate

    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        let stepIndex = navigationController.viewControllers
            .filter { $0 is StepperNavigationProvider }
            .firstIndex(of: viewController)
        guard let index = stepIndex else { return }
        let title = (viewController as? StepperNavigationProvider)?.stepTitle
        stepView.selectStep(atIndex: index, label: title)
    }

    // MARK: - Private

    private func setUp() {
        let stepHeight: CGFloat = 64
        stepView.heightAnchor.constraint(equalToConstant: stepHeight).isActive = true
        navigationController.setNavigationBarExtensionView(stepView, forHeight: stepHeight)
    }
}
