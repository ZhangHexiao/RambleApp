//
//  SelectEventController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class SelectEventController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: RMBBackgroundView!
    
    let viewModel: SelectEventViewModel = SelectEventViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        loadLayout()
        viewModel.loadData()
    }
    
    // MARK: Navigation
    private func loadNavbar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Select An Event".localized
        
        let itemCancel = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(actionCancel))
        navigationItem.leftBarButtonItem = itemCancel
        
        let itemSend = UIBarButtonItem(title: "Send".localized, style: .plain, target: self, action: #selector(actionSend))
        navigationItem.rightBarButtonItem = itemSend
    }
    
    // MARK: Layout
    
    private func loadLayout() {
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: SelectEventCell.self)
    }
    
    // MARK: - Actions
    @objc private func actionCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func actionSend() {
        viewModel.sendInvitation()
        showSuccess(success: "Done".localized)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - SelectEventDelegate
extension SelectEventController: SelectEventDelegate {
    func didFail(error: String, removeFromTop: Bool) {
        stopLoading { [weak self] in
            self?.showError(err: error)
        }
        if removeFromTop {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func didLoadData() {
        emptyView.isHidden = !viewModel.isEmpty
        tableView.reloadData()
    }
}

// MARK: - UITableViewDe
extension SelectEventController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: SelectEventCell.self, indexPath: indexPath)
        cell.configure(with: viewModel.event(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(at: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SelectEventCell.kHeight
    }
}

extension SelectEventController {
    static var instance: SelectEventController {
        guard let vc = Storyboard.Home.viewController(for: .selectEvent) as? SelectEventController else {
            assertionFailure("Something wrong while instantiating SelectEventController")
            return SelectEventController()
        }
        return vc
    }
}
