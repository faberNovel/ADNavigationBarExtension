//
//  StepView.swift
//  NavigationBarExtension_Example
//
//  Created by Samuel Gallet on 29/01/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class StepView: UIView {

    var number: Int = 0 {
        didSet {
            labelCount.text = String(number)
        }
    }
    var title: String? {
        didSet {
            labelTitle.text = title
        }
    }

    private lazy var labelCount = UILabel()
    private lazy var labelTitle = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.ad_pinToSuperview()
        stackView.addArrangedSubview(labelCount)
        stackView.addArrangedSubview(labelTitle)
        stackView.alignment = .center
        let size: CGFloat = 24
        labelCount.textAlignment = .center
        labelCount.heightAnchor.constraint(equalToConstant: size).isActive = true
        labelCount.widthAnchor.constraint(equalToConstant: size).isActive = true
        labelCount.layer.cornerRadius = size / 2
        labelCount.layer.borderColor = UIColor.black.cgColor
        labelCount.layer.borderWidth = 1
    }
}
