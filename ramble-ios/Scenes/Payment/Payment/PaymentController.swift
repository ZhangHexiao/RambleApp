//
//  PaymentController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class PaymentController: CardViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buyButton: RMBButton!
    
    var viewModel: PaymentViewModel
    var getSectionController : GetSectionController!
    
    public init(viewModel: PaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        super.cardHeight = 450
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavbar()
        setupTableView()
        navigationController?.setNavigationBarHidden(false, animated: false)
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        viewModel.fetch()
        loadLayout()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        viewModel.tickets.first?.numberTicketSelected = 0
//    }
    
    // MARK: Navigation
    func loadNavbar() {
        navigationController?.setBack()
        //        navigationItem.title = "Payment".localized
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: Layout
    func loadLayout() {
        buyButton.setTitle(viewModel.buttonTitle, for: .normal)
        if viewModel.tickets.first?.numberTicketSelected ?? 0 <= 0 {
            buyButton.theme = viewModel.sendButtonTheme().rawValue
            buyButton.isEnabled = false
        } else {
            buyButton.theme = viewModel.sendButtonTheme().rawValue
            buyButton.isEnabled = true
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: EventCell.self)
        tableView.registerNib(cellClass: CreditCardCell.self)
        tableView.registerNib(cellClass: GuestNumberCell.self)
        tableView.registerNib(cellClass: OrderCell.self)
        tableView.contentInsetAdjustmentBehavior = .automatic
        //        automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - Actions
    
    @IBAction func actionBuy() {
        showLoading()
        viewModel.buyTickets()
    }
}

// MARK: - PaymentViewModelDelegate
extension PaymentController: PaymentViewModelDelegate {
    func emptyCardFail() {
        stopLoading()
        let cardViewModel = CardViewModel()
        cardViewModel.inject(card: viewModel.cards.first)
        let cardView = AddCreditCardController(viewModel: cardViewModel, delegate: self)
        navigationController?.pushViewController(cardView, animated: true)
        //        if removeFromTop {
        //            navigationController?.popViewController(animated: true)
        //        }
    }
    
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
    
    func didBuySuccess(ticketsBoughtViewModel: TicketsBoughtViewModel) {
        
        stopLoading { [weak self] in
            self?.showSuccess(success: "Ticket(s) bought!".localized)
            //Set the reminder to invite user to rate
            self?.viewModel.setReviewReminder()
            let ticketsBought = TicketsBoughtController(viewModel: ticketsBoughtViewModel)
            guard let navigationControllerIndex = self?.navigationController?.viewControllers.count else {
                self?.navigationController?.popViewController(animated: true)
                return
            }
            
            self?.navigationController?.viewControllers[navigationControllerIndex-2] = ticketsBought
            self?.navigationController?.popViewController(animated: false)
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension PaymentController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(cellClass: EventCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.event)
            return cell
            
        case 1:
            let cardViewModel = CardViewModel()
            cardViewModel.inject(card: viewModel.cards.first)
            let cell = tableView.dequeue(cellClass: CreditCardCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.creditCard, subTitle: viewModel.creditCardActionTitle, cardViewModel: cardViewModel)
            return cell
            
        case 2:
            let cell = tableView.dequeue(cellClass: GuestNumberCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.tickets.first?.numberTicketSelected ?? 0)
            return cell
            
        case 3:
            let cell = tableView.dequeue(cellClass: OrderCell.self, indexPath: indexPath)
            cell.configure(with: viewModel.orderViewModel)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: break
        case 1:
            
            let cardViewModel = CardViewModel()
            cardViewModel.inject(card: viewModel.cards.first)
            
            let cardView = AddCreditCardController(viewModel: cardViewModel, delegate: self)
            navigationController?.pushViewController(cardView, animated: true)
        // triger child controller
        case 2:
            if getSectionController == nil {
                setupCard()
            }
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        case 3: break
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return EventCell.kHeight
        case 1: return CreditCardCell.kHeight
        case 2: return GuestNumberCell.kHeight
        case 3: return UITableView.automaticDimension
        default: return 0
        }
    }
}

extension PaymentController: GetSectionDelegate {
    
    func slideDownSectionController(tickets: [TicketViewModel]) {
        super.animateTransitionIfNeeded(state: nextState, duration: 0.9)
        self.viewModel.tickets = tickets
        self.didLoadData()
    }
}
extension PaymentController: addCardDelegate {
    func updateContent(){
       self.didLoadData()
    }
}

extension PaymentController {
    
    func setupCard() {
        let getSectionViewModel = GetSectionViewModel(event: viewModel.tickets[0].event ?? Event(), tickets: viewModel.tickets)
        let getSectionsController = GetSectionController(viewModel: getSectionViewModel)
        getSectionsController.delegate = self
        self.addChild(getSectionsController)
        self.view.addSubview(getSectionsController.view)
        super.childController = getSectionsController
        super.viewAddGesture = getSectionsController.topView
        getSectionsController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        getSectionsController.view.clipsToBounds = true
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(super.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(super.handleCardPan(recognizer:)))
        
//        getSectionsController.topView.addGestureRecognizer(tapGestureRecognizer)
        getSectionsController.topView.addGestureRecognizer(panGestureRecognizer)
    }
    
}
