//
//  SwitchExtensionTableViewController.swift
//  NavigationBarExtension_Example
//
//  Created by Samuel Gallet on 21/01/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import ADUtils
import NavigationBarExtension
import UIKit

class SwitchExtensionTableViewController: UIViewController {

    private let navBarExtended: Bool

    init(navBarExtended: Bool) {
        self.navBarExtended = navBarExtended
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = navBarExtended ? "Ex" : "Nex"
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.register(cell: .class(UITableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.ad_pinToSuperview()
        tableView.tableFooterView = UIView()
    }
}

extension SwitchExtensionTableViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueCell(at: indexPath)
        cell.textLabel?.text = indexPath.row == 0 ? "Push extended nav bar" : "Push not extended nav bar"
        if indexPath.row.isMultiple(of: 2) {
            cell.contentView.backgroundColor = .blue
        } else {
            cell.contentView.backgroundColor = .white
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let navBarExtension = indexPath.row == 0
        navigationController?.pushViewController(
            SwitchExtensionTableViewController(navBarExtended: navBarExtension),
            animated: true
        )
    }
}

extension SwitchExtensionTableViewController: ExtensibleNavigationBarInformationProvider {

    var shouldExtendNavigationBar: Bool {
        return navBarExtended
    }
}
