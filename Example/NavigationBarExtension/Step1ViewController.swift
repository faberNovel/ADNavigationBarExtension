//
//  Step1ViewController.swift
//  NavigationBarExtension_Example
//
//  Created by Samuel Gallet on 29/01/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class Step1ViewController: UIViewController, UITableViewDataSource {

    private lazy var tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NavBar extension"
        view.addSubview(tableView)
        tableView.ad_pinToSuperview()
        tableView.register(cell: .class(UITableViewCell.self))
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: self,
            action: #selector(nextStep)
        )
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueCell(at: indexPath)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "First name"
        case 1:
            return "Last name"
        case 2:
            return "Email"
        default:
            return nil
        }
    }

    @objc private func nextStep() {
        let vc = Step2ViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension Step1ViewController: StepperNavigationProvider {

    var stepTitle: String? {
        return "Step 1"
    }
}

