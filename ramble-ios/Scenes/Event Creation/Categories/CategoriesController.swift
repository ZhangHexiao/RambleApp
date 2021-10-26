//
//  CategoriesController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-02.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

protocol CategoriesControllerDelegate: class {
    func didSelect(category: CategoryType)
}

class CategoriesController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: CategoriesControllerDelegate?
    var categorySelected: CategoryType = .arts
    var categories: [CategoryType] = CategoryType.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        loadLayout()
    }
    
    // MARK: Navigation
    private func loadNavbar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Category".localized
        
        let itemDone =  UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(actionDone))
        navigationItem.rightBarButtonItem = itemDone
    }
    
    // MARK: Layout
    private func loadLayout() {
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: CategoryCell.self)
    }
    
    // MARK: - Actions
    @objc private func actionDone() {
        delegate?.didSelect(category: categorySelected)
        navigationController?.popViewController(animated: true)
    }
}

extension CategoriesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: CategoryCell.self, indexPath: indexPath)
        let category = categories[indexPath.row]
        cell.configure(with: category, isSelected: category == categorySelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CategoryCell.kHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        categorySelected = category
        tableView.reloadData()
    }
}

extension CategoriesController {
    static var instance: CategoriesController {
        guard let vc = Storyboard.EventCreation.viewController(for: .categories) as? CategoriesController else {
            assertionFailure("Something wrong while instantiating CategoriesController")
            return CategoriesController()
        }
        return vc
    }
}
