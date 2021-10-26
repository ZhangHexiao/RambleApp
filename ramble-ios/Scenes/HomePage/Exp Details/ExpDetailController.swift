//
//  ExpDetailController.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-09.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit
import DTPhotoViewerController

class ExpDetailController: CardViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var bookButton: UIButton!
    
    @IBOutlet weak var interestButton: UIButton!
    
    @IBOutlet weak var moreButton: UIButton!

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var dollarSign: UILabel!
    
    @IBOutlet weak var perPerson: UILabel!
    var calendarSelectionController : CalendarSelectionController!
    var viewModel: ExpDetailViewModel
    var tableViewDataSource: ExpDetailDataSource?
    lazy var ratingController = RatingViewController(event: (self.viewModel.eventViewModel.event))
    
    public init(viewModel: ExpDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        super.cardHeight = 640
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
//        bottomView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLayout()
        loadNavbar()
        navigationController?.setNavigationBarHidden(true, animated: false)
        ExpDetailDataSource.setupEventDetails(tableView: tableView)
        tableViewDataSource = ExpDetailDataSource(viewModel: viewModel, delegate: self)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDataSource
        tableView.remembersLastFocusedIndexPath = true
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
//        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: Navigation
    //We use a fake navbar, and add two buttons
    func loadNavbar() {
        if !viewModel.showNavItem() {
            interestButton.isHidden = true
            moreButton.isHidden = true
        }
    }

    // MARK: Layout
    func loadLayout() {
        view.layoutIfNeeded()
        price.text = viewModel.eventViewModel.minPrice
        if price.text == "Free" {
            dollarSign.isHidden = true
            perPerson.isHidden = true
        }
        bookButton.applyGradient(colours: [UIColor.AppColors.buttonLeft, UIColor.AppColors.buttonRight])
        bookButton.clipsToBounds = true
//        bookButton.title(for: <#T##UIControl.State#>)
        interestButton.setImage(viewModel.interestedIcon, for: .normal)
        
    }
    
    // MARK: - Actions
    @objc private func actionMore() {
        if viewModel.eventViewModel.isMine {
            RMBActionSheet.eventActions.show(on: self) { [weak self] (actionDetail) in
                switch actionDetail {
                case .edit: self?.goEdit()
                //              ======add the replictae option==============
                case .duplicate: self?.goDuplicate()
                //              ============================================
                case .cancel: self?.confirmCancelation()
                case .delete: self?.confirmDeleting()
                default: break
                }
            }
        } else if viewModel.eventViewModel.hasBoughtTickets == true && viewModel.eventViewModel.endAt ?? Date() < Date(){
            RMBActionSheet.reportOrRate.show(on: self) { [weak self] (actionDetail) in
                switch actionDetail {
                case .reportEvent: self?.viewModel.report()
                case .share: self?.didTapShare()
                case .rateExperience:
                    if (self?.viewModel.eventViewModel.hasReviewed)! {
                        self?.ratingController = RatingViewController(event: (self?.viewModel.eventViewModel.event)!, review: (self?.viewModel.eventViewModel.event.reviews!.first)!)
                            }
                            self?.navigationController?.pushViewController(self!.ratingController, animated: true)
                default: break
                }
            }
        } else{
            RMBActionSheet.report.show(on: self) { [weak self] (actionDetail) in
            switch actionDetail {
            case .reportEvent: self?.viewModel.report()
            case .share: self?.didTapShare()
            default: break
            }
            }
        }
    }

    // MARK: - Private
    private func goEdit() {
        let editEvent = NewEventController(viewModel: viewModel.newEventViewModel)
        editEvent.delegate = self
        navigationController?.pushViewController(editEvent, animated: true)
    }
    
    // ===Add function for duplicating event==
    private func goDuplicate() {
        let viewModel_duplicate = viewModel.newDulplicateEventViewModel
        let duplicateEvent = NewEventController(viewModel: viewModel_duplicate)
        duplicateEvent.delegate = self
        navigationController?.pushViewController(duplicateEvent, animated: true)
    }
   // =======================================
    private func confirmCancelation() {
        RMBAlert.confirmCancelEvent.show(on: self) { [weak self] _ in self?.viewModel.cancel() }
    }
    
    private func confirmDeleting() {
        RMBAlert.confirmDeleteEvent.show(on: self) { [weak self] _ in self?.viewModel.delete() }
    }
    
    private func goWeb(url: URL?) {
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - ExpDetailViewModelDelegate
extension ExpDetailController: ExpDetailViewModelDelegate {
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
    
    func didFetchAdditionalItems() {
        stopLoading()
        //        bottomView.interestedButton.isEnabled = true
        loadLayout()
        
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
            self.tableView.endUpdates()
        }
    }
    
    func didUpdateImage() {
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
}
// MARK: - NewEventControllerDelegate
extension ExpDetailController: NewEventControllerDelegate{
    func didUpdateEvent() {
        viewModel.fetchEvent()
    }
}

// MARK: - EventDetailsListDataSourceDelegate
extension ExpDetailController: ExpDetailDataSourceDelegate {
    func changeTitleOpaque(value: CGFloat) {
        
        if value == 190 {
            interestButton.isHidden = true
            moreButton.isHidden = true
            backButton.isHidden = true
        } else {
            interestButton.isHidden = false
            moreButton.isHidden = false
            backButton.isHidden = false
        }
           interestButton.alpha = (190 - value)/150
           moreButton.alpha = (190 - value)/150
           backButton.alpha = (190 - value)/150
    }
        
    func didTapSeeMyTickets() {
        guard let ticketsBoughtViewModel = viewModel.ticketsBoughtViewModel else { return }
        let ticketsBought = TicketsBoughtController(viewModel: ticketsBoughtViewModel)
        navigationController?.pushViewController(ticketsBought, animated: true)
    }
    
    func didSelectOutsideTickets() {
        goWeb(url: viewModel.eventViewModel.ticketsWebLinkURL)
    }
    
    func didSelectLocation() {
        let coordinates = viewModel.eventViewModel.coordinates
        RMBActionSheet.map.show(on: self) { [weak self] (actionDetail) in
            switch actionDetail {
            case .appleMaps: self?.goWeb(url: Const.Url.appleMapUrl(coordinates: coordinates))
            case .googleMaps: self?.goWeb(url: Const.Url.googleMapUrl(coordinates: coordinates))
            default: break
            }
        }
    }
    
    func didTapImage(_ image: UIImage?, imageView: UIImageView?) {
        let vc = DTPhotoViewerController(referencedView: imageView, image: image)
        present(vc, animated: true, completion: nil)
    }
}

extension ExpDetailController {
    func didBook() {
        print("fix me in the future")
    }
    
    func didTapInsterested() {
        if User.current() == nil {
            blockGuest()
        } else {
            showLoading()
            viewModel.actionInterested()
        }
    }
    
    func didTapShare() {
        guard let id = viewModel.eventViewModel.event.objectId, let url = URL(string: "\(Const.Url.shareLink)\(id)") else {
            return
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
     
    func didTapTickets() {
        if viewModel.eventViewModel.hasBadge {
            let tickets = GetTicketsController(viewModel: viewModel.getTicketsViewModel)
            navigationController?.pushViewController(tickets, animated: true)
        } else if let web = viewModel.eventViewModel.ticketsWebLinkURL {
            goWeb(url: web)
        }
    }
    
}


extension ExpDetailController: HostInfoCellDelegate {
        
    func didTapContact() {
        if User.current() == nil {
            blockGuest()
        } else {
            MessagesManager().createMessageItem(event: self.viewModel.eventViewModel.event){[weak self] (messages: [Message], error: String?) in
                if error != nil {
                    self?.showError(err: error!)
                    return
                }else {
                    let messageToLoad = messages.first
                    self?.navigationController?.pushViewController(BasicExampleViewController(message: messageToLoad!), animated: true)
                }
            }//end of create item
        }//end of else
    }//end of didTapContact
}
extension ExpDetailController {
    
    @IBAction func bookAction(_ sender: Any) {

        if calendarSelectionController == nil {
            setupCard()
        }
        animateTransitionIfNeeded(state: nextState, duration: 0.9)
    }
    
    @IBAction func interestAction(_ sender: Any) {
       didTapInsterested()
    }

    @IBAction func seeMoreAction(_ sender: Any) {
       actionMore()
    }
    
    @IBAction func tapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension ExpDetailController {
    
    func setupCard() {
//        visualEffectView = UIVisualEffectView()
//        visualEffectView.frame = UIScreen.main.boundss
//        self.view.addSubview(visualEffectView)
        calendarSelectionController = CalendarSelectionController.instance
        let viewModel = CalendarSelectionViewModel(viewModel: self.viewModel, calendarSelection: calendarSelectionController)
        calendarSelectionController.viewModel = viewModel
        self.addChild(calendarSelectionController)
        self.view.addSubview(calendarSelectionController.view)
        super.childController = calendarSelectionController
        super.viewAddGesture = calendarSelectionController.topView
        calendarSelectionController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        calendarSelectionController.view.clipsToBounds = true
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(super.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(super.handleCardPan(recognizer:)))
        
//        calendarSelectionController.topView.addGestureRecognizer(tapGestureRecognizer)
        calendarSelectionController.topView.addGestureRecognizer(panGestureRecognizer)
    }
    
}
