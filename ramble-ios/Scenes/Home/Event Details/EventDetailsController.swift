////
////  EventDetailsController.swift
////  ramble-ios
////  Created by Hexiao Zhang on 2020-06-10.
////  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
////
//
//import Foundation
//import UIKit
//import DTPhotoViewerController
//
//class EventDetailsController: BaseController {
//    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var bottomView: EventDetailsBottomView!
//    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint! // 91
//    
//    var viewModel: EventDetailsViewModel
//    var tableViewDataSource: EventDetailsListDataSource?
//    private var shadowImageView: UIImageView?
//    lazy var ratingController = RatingViewController(event: (self.viewModel.eventViewModel.event))
//    
//    public init(viewModel: EventDetailsViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//        hidesBottomBarWhenPushed = true
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        viewModel.delegate = self
//        bottomView.delegate = self
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadLayout()
//        loadNavbar()
//        EventDetailsListDataSource.setupEventDetails(tableView: tableView)
//        tableViewDataSource = EventDetailsListDataSource(viewModel: viewModel, delegate: self)
//        tableView.dataSource = tableViewDataSource
//        tableView.delegate = tableViewDataSource
//        tableView.remembersLastFocusedIndexPath = true
//        //        automaticallyAdjustsScrollViewInsets = false
//        tableView.contentInsetAdjustmentBehavior = .never
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
////        shadowImageView?.isHidden = false
//    }
//    
//    // MARK: Navigation
//    func loadNavbar() {
//        navigationController?.setBack()
//        navigationItem.titleView = nil
//        navigationItem.title = viewModel.navTitle
//        navigationItem.rightBarButtonItem = nil
//        if viewModel.showNavItem() {
//            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_dots"), style: .plain, target: self, action: #selector(actionMore))
//        }
////
////        if shadowImageView == nil {
////            shadowImageView = findShadowImage(under: navigationController!.navigationBar)
////        }
////        shadowImageView?.isHidden = true
//    }
//    
//    // MARK: Layout
//    func loadLayout() {
//        bottomViewHeight.constant = viewModel.showBottomView() ? 75 : 0
//        view.layoutIfNeeded()
//        bottomView.configure(interestedIcon: viewModel.interestedIcon, hasTickets: viewModel.showGetTicketsButton())
//    }
//    
//    // MARK: - Actions
//    @objc private func actionMore() {
//        if viewModel.eventViewModel.isMine {
//            RMBActionSheet.eventActions.show(on: self) { [weak self] (actionDetail) in
//                switch actionDetail {
//                case .edit: self?.goEdit()
//                //              ======add the replictae option==============
//                case .duplicate: self?.goDuplicate()
//                //              ============================================
//                case .cancel: self?.confirmCancelation()
//                case .delete: self?.confirmDeleting()
//                default: break
//                }
//            }
//        } else if viewModel.eventViewModel.hasBoughtTickets == true && viewModel.eventViewModel.endAt ?? Date() < Date(){
//            RMBActionSheet.reportOrRate.show(on: self) { [weak self] (actionDetail) in
//                switch actionDetail {
//                case .reportEvent: self?.viewModel.report()
//                case .rateExperience:
//                    if (self?.viewModel.eventViewModel.hasReviewed)! {
//                        self?.ratingController = RatingViewController(event: (self?.viewModel.eventViewModel.event)!, review: (self?.viewModel.eventViewModel.event.reviews!.first)!)
//                            }
//                            self?.navigationController?.pushViewController(self!.ratingController, animated: true)
//                default: break
//                }
//            }
//        } else{
//            RMBActionSheet.report.show(on: self) { [weak self] (actionDetail) in
//                self?.viewModel.report()
//            }
//        }
//    }
//    
//    // MARK: - Private
//    private func goEdit() {
//        let editEvent = NewEventController(viewModel: viewModel.newEventViewModel)
//        editEvent.delegate = self
//        navigationController?.pushViewController(editEvent, animated: true)
//    }
//    
//    // ===Add function for duplicating event==
//    private func goDuplicate() {
//        let viewModel_duplicate = viewModel.newDulplicateEventViewModel
//        let duplicateEvent = NewEventController(viewModel: viewModel_duplicate)
//        duplicateEvent.delegate = self
//        navigationController?.pushViewController(duplicateEvent, animated: true)
//    }
//    // =======================================
//    
//    private func confirmCancelation() {
//        RMBAlert.confirmCancelEvent.show(on: self) { [weak self] _ in self?.viewModel.cancel() }
//    }
//    
//    private func confirmDeleting() {
//        RMBAlert.confirmDeleteEvent.show(on: self) { [weak self] _ in self?.viewModel.delete() }
//    }
//    
//    private func goWeb(url: URL?) {
//        if let url = url, UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
//}
//
//// MARK: - EventDetailsViewModelDelegate
//extension EventDetailsController: EventDetailsViewModelDelegate {
//    func didFail(error: String, removeFromTop: Bool) {
//        stopLoading { [weak self] in
//            self?.showError(err: error)
//        }
//        
//        if removeFromTop {
//            navigationController?.popViewController(animated: true)
//        }
//    }
//    
//    func didSuccess(msg: String, removeFromTop: Bool) {
//        stopLoading { [weak self] in
//            self?.showSuccess(success: msg)
//        }
//        
//        if removeFromTop {
//            navigationController?.popViewController(animated: true)
//        }
//    }
//    
//    func didFetchAdditionalItems() {
//        stopLoading()
//        //        bottomView.interestedButton.isEnabled = true
//        loadLayout()
//        UIView.performWithoutAnimation {
//            self.tableView.beginUpdates()
//            self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
//            self.tableView.endUpdates()
//        }
//    }
//    
//    func didUpdateImage() {
//        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
//    }
//}
//
//// MARK: - NewEventControllerDelegate
//extension EventDetailsController: NewEventControllerDelegate{
//    func didUpdateEvent() {
//        viewModel.fetchEvent()
//    }
//}
//
//// MARK: - EventDetailsListDataSourceDelegate
//extension EventDetailsController: EventDetailsListDataSourceDelegate {
//    
//    func didTapSeeMyTickets() {
//        guard let ticketsBoughtViewModel = viewModel.ticketsBoughtViewModel else { return }
//        let ticketsBought = TicketsBoughtController(viewModel: ticketsBoughtViewModel)
//        navigationController?.pushViewController(ticketsBought, animated: true)
//    }
//    
//    func didSelectOutsideTickets() {
//        goWeb(url: viewModel.eventViewModel.ticketsWebLinkURL)
//    }
//    
//    func didSelectLocation() {
//        let coordinates = viewModel.eventViewModel.coordinates
//        RMBActionSheet.map.show(on: self) { [weak self] (actionDetail) in
//            switch actionDetail {
//            case .appleMaps: self?.goWeb(url: Const.Url.appleMapUrl(coordinates: coordinates))
//            case .googleMaps: self?.goWeb(url: Const.Url.googleMapUrl(coordinates: coordinates))
//            default: break
//            }
//        }
//    }
//    
//    func didTapSeeAllFriends() {
//        let interestedUsers = InterestedUsersController.instance
//        
//        interestedUsers.viewModel = InterestedUsersViewModel(eventViewModel: viewModel.eventViewModel, friendsViewModel: viewModel.eventViewModel.friendsViewModel)
//        
//        navigationController?.pushViewController(interestedUsers, animated: true)
//    }
//    /* block user from seeing others profils*/
//    func didTapSeeProfileDetails(profileViewModel: ProfileViewModel) {
//        //        let controller = ProfileController.instance
//        //        controller.hidesBottomBarWhenPushed = true
//        //        controller.viewModel = profileViewModel
//        //        navigationController?.pushViewController(controller, animated: true)
//    }
//    
//    func didTapImage(_ image: UIImage?, imageView: UIImageView?) {
//        let vc = DTPhotoViewerController(referencedView: imageView, image: image)
//        present(vc, animated: true, completion: nil)
//    }
//}
//
//extension EventDetailsController: EventDetailsBottomViewDelegate {
//    func didTapTickets() {
//        if viewModel.eventViewModel.hasBadge {
//            let tickets = GetTicketsController(viewModel: viewModel.getTicketsViewModel)
//            navigationController?.pushViewController(tickets, animated: true)
//        } else if let web = viewModel.eventViewModel.ticketsWebLinkURL {
//            goWeb(url: web)
//        }
//    }
//    
//    func didTapShare() {
//        guard let id = viewModel.eventViewModel.event.objectId, let url = URL(string: "\(Const.Url.shareLink)\(id)") else {
//            return
//        }
//        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//        present(vc, animated: true, completion: nil)
//    }
//    
//    func didTapInsterested() {
//        if User.current() == nil {
//            blockGuest()
//        } else {
//            showLoading()
//            viewModel.actionInterested()
//        }
//    }   
//    func didTapContact() {
//        if User.current() == nil {
//            blockGuest()
//        } else {
//            MessagesManager().createMessageItem(event: self.viewModel.eventViewModel.event){[weak self] (messages: [Message], error: String?) in
//                if error != nil {
//                    self?.showError(err: error!)
//                    return
//                }else {
//                    let messageToLoad = messages.first
//                    self?.navigationController?.pushViewController(BasicExampleViewController(message: messageToLoad!), animated: true)
//                }
//            }//end of create item
//        }//end of else
//    }//end of didTapContact
//}
//
//extension EventDetailsController {
//private func findShadowImage(under view: UIView) -> UIImageView? {
//    if view is UIImageView && view.bounds.size.height <= 1 {
//        return (view as! UIImageView)
//    }
//
//    for subview in view.subviews {
//        if let imageView = findShadowImage(under: subview) {
//            return imageView
//        }
//    }
//    return nil
//}
//}
