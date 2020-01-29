//
//  CountriesViewController.swift
//  NavigationBarExtension_Example
//
//  Created by Samuel Gallet on 29/01/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class CountriesViewController: UIViewController, UITableViewDataSource {
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        view.addSubview(tableView)
        tableView.ad_pinToSuperview()
        tableView.register(cell: .class(UITableViewCell.self))
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueCell(at: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = indexPath.row.isMultiple(of: 2) ? "France" : "US"
        return cell
    }
}
