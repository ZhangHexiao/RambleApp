//
//  FilterController.swift
//  ramble-ios
//  Hexiao Zhang
//  Created by Ramble Technologies on 2018-07-19.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol FilterControllerDelegate: class {
    func didUpdateFilter()
}

class FilterController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FilterControllerDelegate?
    lazy var viewModel = FilterViewModel(pageType:self.pageType!) as FilterViewModel
    var pageType: String?
    public init(pageType:String) {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        self.pageType = pageType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadNavbar()
    }
    
    // MARK: Navigation
    func loadNavbar() {
        navigationItem.title = "Filters".localized
        
        let itemCancel = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(actionCancel))
        
        let itemClearAll = UIBarButtonItem(title: "Clear All".localized, style: .plain, target: self, action: #selector(actionClearAll))
        
        navigationItem.leftBarButtonItem = itemCancel
        navigationItem.rightBarButtonItem = itemClearAll
    }
    
    // MARK: Layout
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: CategoryCell.self)
        tableView.registerNib(cellClass: FilterDateCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
//        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: - Actions
    @objc private func actionCancel() {
       delegate?.didUpdateFilter()
       navigationController?.popViewController(animated: true)
    }
    
    @objc private func actionClearAll() {
        viewModel.clearAll()
    }
    
    @IBAction func actionDone() {
        viewModel.save(pageType:self.pageType!)
        delegate?.didUpdateFilter()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - extension FilterController: FilterViewModelDelegate
extension FilterController: FilterViewModelDelegate {
    func didLoad() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilterController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return viewModel.allCategories.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeue(cellClass: FilterDateCell.self, indexPath: indexPath)
                cell.configure(with: "From".localized, title: viewModel.fromDateFormatted())
                return cell
            } else {
                let cell = tableView.dequeue(cellClass: FilterDateCell.self, indexPath: indexPath)
                cell.configure(with: "To".localized, title: viewModel.toDateFormatted())
                return cell
            }
        case 1:
            let cell = tableView.dequeue(cellClass: CategoryCell.self, indexPath: indexPath)
            let category = viewModel.allCategories[indexPath.row]
            cell.configure(with: category, isSelected: viewModel.isCategorySelected(category: category))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let selectDate = SelectDateController.instance
                selectDate.viewModel.dateType = .startAt
                selectDate.delegate = self
                selectDate.viewModel.injectDate(date: viewModel.fromDate)
                navigationController?.pushViewController(selectDate, animated: true)
            } else {
                let selectDate = SelectDateController.instance
                selectDate.viewModel.dateType = .endAt
                selectDate.delegate = self
                selectDate.viewModel.injectDate(date: viewModel.toDate)
                navigationController?.pushViewController(selectDate, animated: true)
            }
        case 1:
            let category = viewModel.allCategories[indexPath.row]
            viewModel.toggle(category: category)
            tableView.reloadRows(at: [indexPath], with: .none)
        default: break
          
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FilterDateCell.kHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SimpleTextSection.kHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SimpleTextSection.fromNib()
        switch section {
        case 0:
            headerView.configure(with: "Dates".localized, appearanceType: .category)
        case 1:
            headerView.configure(with: "Categories".localized, appearanceType: .category)
        default:
            headerView.configure(with: "", appearanceType: .category)
        }
        return headerView
    }
}

extension FilterController: SelectDateControllerDelegate {
    func didSelect(date: Date, type: DateType) {
        switch type {
        case .startAt:
            if let toDate = viewModel.toDate {
                if date > toDate {
                    showError(err: RMBError.invalidStartEventAfterEndDate.localizedDescription)
                    return
                }
            }
            viewModel.fromDate = date
        case .endAt:
            if let fromDate = viewModel.fromDate {
                if date < fromDate {
                    showError(err: RMBError.invalidEndEventBeforeStartDate.localizedDescription)
                    return
                }
            }
            viewModel.toDate = date
        }
        
        tableView.reloadData()
    }
}
