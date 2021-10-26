//
//  ProfileController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-19.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//
import UIKit

class ProfileController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint! // 90
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(actionRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    var viewModel = ProfileViewModel()
    
    var dataSource: ProfileDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        showLoading()
        viewModel.loadData()
        if User.current() == nil { stopLoading() }
        
        tableView.registerNib(cellClass: EventCell.self)
        tableView.registerNib(cellClass: ProfileCoverCell.self)
        tableView.registerNib(cellClass: ListFriendsCell.self)
//        tableView.registerNib(cellClass: ConnectFacebookCell.self)
        tableView.addSubview(refreshControl)
        
//        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        loadLayout()

        dataSource = ProfileDataSource(viewModel: viewModel, delegate: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
    }
    
    // MARK: Navigation
    func loadNavbar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        switch viewModel.profileType {
        case .mine:
            let itemNew = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_simple_add"), style: .plain, target: self, action: #selector(actionNew))
            let itemSettings =  UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(actionSettings))
            navigationItem.leftBarButtonItem = itemNew
            navigationItem.rightBarButtonItem = itemSettings
        case .friend:
            navigationController?.setBack()
        }
        navigationItem.title = viewModel.fullName
    }
    
    // MARK: Layout
    func loadLayout() {

        switch viewModel.profileType {
        case .mine:
            bottomViewHeight.constant = 0
        case .friend:
            bottomViewHeight.constant = 75
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    @objc private func actionNew() {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "PromoterApp", bundle: nil)
        let popOverController = storyboard.instantiateViewController(withIdentifier: "PopPromoterController")
                   
           present(popOverController, animated: true)
        
        
//  ++++++++++++++Currently Block User from creating the new Event++++++++++++++
//        let controller = NewEventController()
//        controller.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(controller, animated: true)
//  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    }
    
    @objc private func actionSettings() {
        let controller = SettingsController.instance
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func actionRefresh() {
        viewModel.loadData()
    }
    
    @IBAction func actionInvite() {
        let selectEvent = SelectEventController.instance
        selectEvent.viewModel.friend = viewModel.user
        navigationController?.pushViewController(selectEvent, animated: true)
    }
    
    @IBAction func actionMore() {
        RMBActionSheet.reportUser.show(on: self) { [weak self] (actionDetail) in
            switch actionDetail {
            case .reportCover:
                self?.viewModel.reportUser(type: .coverPicture)
            case .reportProfile:
                 self?.viewModel.reportUser(type: .profilePicture)
            default: break
            }
        }
    }
}

// MARK: - ProfileViewModelDelegate
extension ProfileController: ProfileViewModelDelegate {
    
    func didLoadData() {
        refreshControl.endRefreshing()
        stopLoading()
        tableView.reloadData()
    }
    
    func didSuccess(msg: String) {
        refreshControl.endRefreshing()
        stopLoading { [weak self] in
            self?.showSuccess(success: msg)
        }
    }
    func didFail(error: String) {
        stopLoading { [weak self] in
            self?.showError(err: error)
        }
    }
}

extension ProfileController {
    
    private func goEventDetails(eventDetailsViewModel: ExpDetailViewModel) {
        if eventDetailsViewModel.eventViewModel.status != .blocked {
            let eventDetails = ExpDetailController(viewModel: eventDetailsViewModel)
            navigationController?.pushViewController(eventDetails, animated: true)
            return
        }
        
        if eventDetailsViewModel.eventViewModel.isMine {
            RMBAlert.blockedEvent.show(on: self) { [weak self] (_) in
                let contact = ContactController.instance
                contact.viewModel.inject(type: .claimEvent, event: eventDetailsViewModel.eventViewModel)
                self?.navigationController?.pushViewController(contact, animated: true)
            }
        } else {
            showError(err: RMBError.eventBlocked.localizedDescription)
        }
    }
}

// MARK: - ProfileDataSourceDelegate
extension ProfileController: ProfileDataSourceDelegate {
    
    func didTapAction(for section: SectionType) {
        let eventsList = EventsListController.instance
        switch section {
        case .created:
            eventsList.viewModel.eventsType = .created
        case .interested:
            eventsList.viewModel.eventsType = .interested
        case .myTickets:
            eventsList.viewModel.eventsType = .bought
        case .none: return
        }
        eventsList.viewModel.user = viewModel.user
        eventsList.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(eventsList, animated: true)
    }

    func didTapSeeBand() {
//  ==Current hide the Band page for the user's band===
//        if viewModel.profileType == .friend { return }
//        let band = BandController.instance
//        band.nbEvents = viewModel.nbEventsInt
//        navigationController?.pushViewController(band, animated: true)
//  =============================
    }
    
    func didTapSeeEventDetails(eventDetailsViewModel: ExpDetailViewModel) {
        goEventDetails(eventDetailsViewModel: eventDetailsViewModel)
    }
    
//    func didTapSeeAllFriends() {
//        let controller = FriendsListController.instance
//        controller.hidesBottomBarWhenPushed = true
//        controller.viewModel = viewModel.friendsViewModel
//        navigationController?.pushViewController(controller, animated: true)
//    }
    
    func didTapSeeProfileDetails(profileViewModel: ProfileViewModel) {
        let controller = ProfileController.instance
        controller.hidesBottomBarWhenPushed = true
        controller.viewModel = profileViewModel
        navigationController?.pushViewController(controller, animated: true)
    }

//    func didSelectFacebook() {
//        FacebookManager.shared.linkUser { [weak self] (error) in
//            if let err = error {
//                self?.showError(err: err)
//            }
//            self?.viewModel.user = User.current()
//            self?.viewModel.loadData()
//        }
//    }
}

// MARK: - Instance View Controller
extension ProfileController {
    static var instance: ProfileController {
        guard let vc = Storyboard.Profile.viewController(for: .profile) as? ProfileController else {
            assertionFailure("Something wrong while instantiating ProfileController")
            return ProfileController()
        }
        return vc
    }
}
