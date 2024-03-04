//
//  Step2ViewController.swift
//  NavigationBarExtension_Example
//
//  Created by Samuel Gallet on 29/01/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import ADNavigationBarExtension
import UIKit

class Step2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private lazy var tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NavBar extension"
        view.addSubview(tableView)
        tableView.ad_pinToSuperview()
        tableView.register(cell: .class(UITableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: self,
            action: #selector(nextStep)
        )
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueCell(at: indexPath)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section.isMultiple(of: 2) ? "Country" : "Region"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section.isMultiple(of: 2) {
            let viewController = CountriesViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    @objc private func nextStep() {
        let viewController = HideNavigationBarViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension Step2ViewController: StepperNavigationProvider {

    var stepTitle: String? {
        return "Step 2"
    }
}
