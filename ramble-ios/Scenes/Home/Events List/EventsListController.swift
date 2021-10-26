//
//  EventsListController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-31.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class EventsListController: BaseController {
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var pastTableView: UITableView!
    @IBOutlet weak var upcomingTableView: UITableView!
    
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var upcomingButton: UIButton!
    @IBOutlet weak var selectView: UIView!
    
    @IBOutlet weak var selectViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var selectViewLeading: NSLayoutConstraint!

    var viewModel: EventsListViewModel = EventsListViewModel(type: .bought)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViews()
        scrollView.delegate = self
        viewModel.delegate = self
        viewModel.timeEvent = .upcoming
        setUpButtons()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        showLoading()
        viewModel.loadData()
    }
    
    private func setUpButtons() {
        upcomingButton.setTitle("Upcoming".localized, for: .normal)
        pastButton.setTitle("Past".localized, for: .normal)
        selectViewLeading.constant = 0
        selectViewTrailing.constant = UIScreen.main.bounds.width/2
    }
    
    // MARK: Navigation
    private func loadNavbar() {
        switch viewModel.eventsType {
        case .created:
            navigationController?.setBack()
            let itemNew = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_simple_add"), style: .plain, target: self, action: #selector(actionNew))
            navigationItem.rightBarButtonItem = itemNew
        case .bought, .interested:
            navigationController?.setBack()
        }
        title = viewModel.title
    }
    
    private func setupTableViews() {
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        upcomingTableView.registerNib(cellClass: EventCell.self)
        
        pastTableView.delegate = self
        pastTableView.dataSource = self
        pastTableView.registerNib(cellClass: EventCell.self)
        
//        automaticallyAdjustsScrollViewInsets = false
        upcomingTableView.contentInsetAdjustmentBehavior = .never
        pastTableView.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: - Actions
    @IBAction func actionUpcoming() {
        scrollTo(page: TimeEventType.upcoming.rawValue)
    }
    
    @IBAction func actionPast() {
        scrollTo(page: TimeEventType.past.rawValue)
    }
    
    @objc private func actionNew() {
        navigationController?.pushViewController(NewEventController(), animated: true)
    }
}

// MARK: - UITableViewDelegate
extension EventsListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case upcomingTableView: return viewModel.numberOfRows(for: .upcoming)
        case pastTableView: return viewModel.numberOfRows(for: .past)
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: EventCell.self, indexPath: indexPath)
        
        if tableView == upcomingTableView {
            cell.configure(with: viewModel.eventsUpcoming[indexPath.row])
        } else if tableView == pastTableView {
            cell.configure(with: viewModel.eventsPast[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EventCell.kHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goEventDetails(eventDetailsViewModel: viewModel.eventDetailsViewModel(at: indexPath))
    }
    
    private func goEventDetails(eventDetailsViewModel: ExpDetailViewModel) {
        if eventDetailsViewModel.eventViewModel.status != .blocked {
//            let eventDetails = ExpDetailController(viewModel: eventDetailsViewModel)
//            navigationController?.pushViewController(eventDetails, animated: true)
            let eventDetails = ExpDetailController(viewModel: eventDetailsViewModel)
            navigationController?.pushViewController(eventDetails, animated: true)
            return
        }
        
        if eventDetailsViewModel.eventViewModel.isMine {
            
            RMBAlert.blockedEvent.show(on: self) { [weak self] _ in
                let contact = ContactController.instance
                contact.viewModel.inject(type: .claimEvent, event: eventDetailsViewModel.eventViewModel)
                self?.navigationController?.pushViewController(contact, animated: true)
            }
        } else {
            showError(err: RMBError.eventBlocked.localizedDescription)
        }
    }
}

// MARK: - View Model delegate

extension EventsListController: EventsListDelegate {
    func didLoadData() {
        stopLoading()
        upcomingTableView.reloadData()
        pastTableView.reloadData()
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
    
    func didChangeTab() {
        switch viewModel.timeEvent {
        case .upcoming:
            upcomingButton.setTitleColor(.white, for: .normal)
            pastButton.setTitleColor(UIColor.AppColors.unselectedTextGray, for: .normal)
        case .past:
            upcomingButton.setTitleColor(UIColor.AppColors.unselectedTextGray, for: .normal)
            pastButton.setTitleColor(.white, for: .normal)
        }
        view.layoutIfNeeded()
    }
}

// MARK: - ScrollView Delegate
extension EventsListController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // We don't want to do any action when the tableview scrolls
        if scrollView != self.scrollView {
            return
        }
        
        let width = UIScreen.main.bounds.width
        selectViewLeading.constant = scrollView.contentOffset.x/2
        selectViewTrailing.constant = width - (selectViewLeading.constant + width/2)
        
        let offset = scrollView.contentOffset.x
        let page = offset / self.view.bounds.width
        let currentPage = Int(page.rounded())
        
        if currentPage == TimeEventType.upcoming.rawValue {
            viewModel.timeEvent = .upcoming
        } else {
            viewModel.timeEvent = .past
        }
    }
    
    private func scrollTo(page: Int) {
        var offset = scrollView.contentOffset
        
        if page == TimeEventType.upcoming.rawValue {
            offset.x = 0.0
        } else {
            offset.x = self.view.frame.width
        }
        
        scrollView.setContentOffset(offset, animated: true)
    }
}

extension EventsListController {
    static var instance: EventsListController {
        guard let vc = Storyboard.Home.viewController(for: .eventsList) as? EventsListController else {
            assertionFailure("Something wrong while instantiating EventsListController")
            return EventsListController()
        }
        return vc
    }
}
