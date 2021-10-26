//
//  GetTicketController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-20.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

import UIKit

class GetTicketsController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentButton: RMBButton!
    
    var viewModel: GetTicketsViewModel
    
    public init(viewModel: GetTicketsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
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
        loadNavbar()
        loadLayout()
        viewModel.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(#function)
    }
    
    // MARK: Navigation
    private func loadNavbar() {
        navigationController?.setBack()
        navigationItem.title = "Get Tickets".localized
    }
    
    // MARK: Layout
    private func loadLayout() {
        paymentButton.setTitle(viewModel.buttonTitle, for: .normal)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: GetTicketCell.self)
        tableView.registerNib(cellClass: EventCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
//        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: - Actions
    @IBAction func actionGoPayment() {
        if User.current() == nil {
            blockGuest()
            return
        }
        
        if viewModel.hasSelectedMinimumQuantity() {
            let payment = PaymentController(viewModel: viewModel.paymentViewModel)
            navigationController?.pushViewController(payment, animated: true)
        } else {
            showError(err: RMBError.selectTicket.localizedDescription)
        }
    }
}

// MARK: - GetTicketsViewModelDelegate
extension GetTicketsController: GetTicketsViewModelDelegate {
    func didLoadData() {
        tableView.reloadData()
        loadLayout()
    }
    
    func didFail(error: String, removeFromTop: Bool) {
        stopLoading { [weak self] in
            self?.showError(err: error)
        }
        
        if removeFromTop {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func didSuccess(msg: String, removeFromTop: Bool) {
        stopLoading { [weak self] in
            self?.showSuccess(success: msg)
        }
        
        if removeFromTop {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - GetTicketCellDelegate
extension GetTicketsController: GetTicketCellDelegate {
    func didUpdateValue(viewModel: TicketViewModel, cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell) else { return }
        self.viewModel.update(viewModel: viewModel, at: index)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GetTicketsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.numberOfRows(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(cellClass: EventCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.event)
            return cell
        
        case 1:
            let cell = tableView.dequeue(cellClass: GetTicketCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.ticketViewModel(at: indexPath), delegate: self)
            return cell
        
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return EventCell.kHeight
        case 1: return UITableView.automaticDimension
        default: return 0
        }
    }
}
