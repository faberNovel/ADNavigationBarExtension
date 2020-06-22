//
//  NavBarExtensionView.swift
//  NavigationBarExtension_Example
//
//  Created by Samuel Gallet on 29/01/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class NavBarExtensionView: UIView {
    private var steps: [StepView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    func selectStep(atIndex index: Int, label: String?) {
        for stepIndex in 0..<steps.count {
            steps[stepIndex].title = stepIndex == index ? label : nil
        }
    }

    private func setUp() {
        clipsToBounds = true
        steps = (0..<3).map {
            let step = StepView()
            step.number = $0 + 1
            return step
        }
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 72
        for step in steps {
            stackView.addArrangedSubview(step)
        }
        addSubview(stackView)
        stackView.ad_centerInSuperview()
    }
}
