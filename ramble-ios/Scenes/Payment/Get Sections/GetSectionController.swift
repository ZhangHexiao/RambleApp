//
//  ViewController.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-07-08.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol GetSectionDelegate: class {
    func slideDownSectionController(tickets: [TicketViewModel])
}

class GetSectionController: BaseController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var paymentButton: RMBButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: GetSectionViewModel
    weak var delegate: GetSectionDelegate?
    
    public init(viewModel: GetSectionViewModel) {
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
        didLoadData()
//        viewModel.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print(#function)
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
    
    
    @IBAction func actionGoPayment(_ sender: Any) {
        if User.current() == nil {
            blockGuest()
            return
        }
        
        if viewModel.hasSelectedMinimumQuantity() {
            delegate?.slideDownSectionController(tickets: viewModel.tickets)
        } else {
            showError(err: RMBError.selectTicket.localizedDescription)
        }
    }
}

// MARK: - GetTicketsViewModelDelegate
extension GetSectionController: GetSectionViewModelDelegate {
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
extension GetSectionController: GetTicketCellDelegate {
    func didUpdateValue(viewModel: TicketViewModel, cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell) else { return }
        self.viewModel.update(viewModel: viewModel, at: index)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GetSectionController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(cellClass: GetTicketCell.self, indexPath: indexPath)
        cell.configure(with: viewModel.ticketViewModel(at: indexPath), delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



