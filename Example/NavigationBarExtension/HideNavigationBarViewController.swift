//
//  HideNavigationBarViewController.swift
//  NavigationBarExtension_Example
//
//  Created by Samuel Gallet on 06/01/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import ADUtils
import UIKit

class HideNavigationBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let button = UIButton()
        button.setTitle("back", for: .normal)
        view.addSubview(button)
        button.ad_centerInSuperview()
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .primaryActionTriggered)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
