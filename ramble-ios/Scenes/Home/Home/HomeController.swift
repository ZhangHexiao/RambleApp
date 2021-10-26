////
////  HomeController.swift
////  ramble-ios
////  Created by Hexiao Zhang
////  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
////
//
//import UIKit
//import Foundation
//
//class HomeController: BaseController {
//    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var easyToolTipPointView: UIView!
//
//    lazy var refresher: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.tintColor = .white
//        refreshControl.addTarget(self, action: #selector(actionRefresh), for: .valueChanged)
//        return refreshControl
//    }()
//    
//    func endRefresher(refresher: UIRefreshControl){
//        let stoptime = DispatchTime.now() + .milliseconds(400)
//        DispatchQueue.main.asyncAfter(deadline: stoptime){
//            refresher.endRefreshing()
//        }
//    }
//    
//    lazy var spinner: UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView(style: .white)
//        if #available(iOS 13.0, *) {
//            let spinner = UIActivityIndicatorView(style: .large)
//        }
//        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
//        return spinner
//    }()
//    
//    let viewModel = HomeViewModel()
//    var dataSource: HomeDataSource?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        viewModel.delegate = self
//        tableView.estimatedRowHeight = HomeEventCell.kHeight
//
//        showLoading()
//        
//        dataSource = HomeDataSource(viewModel: viewModel, delegate: self)
//        tableView.delegate = dataSource
//        tableView.dataSource = dataSource
//        
//        self.tabBarController?.delegate = self
//        
//        viewModel.nbSkip = 0
//        viewModel.loadEvents()
//        viewModel.seeIfEventExist()
//        
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //update near by events
//        loadNavbar()
//        navigationItem.titleView = makeTitleView()
//        DiscoveryAPIManager.shared.updateEvents()
//        viewModel.updateStartingSoon()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        viewModel.fetchUnreadNotification()
//        
//        if UserDefaults.shouldShowToolTip(for: .createEvent) {
//            showToolTipCreateEvent()
//        }
//    }
//    
//    // MARK: Navigation
//    private func loadNavbar() {
/////==   =this part is repeated in the MakeTitleView function===
////        navigationItem.title = "ramble"
////        navigationController?.navigationBar.titleTextAttributes = [
////        NSAttributedString.Key.font: Fonts.Futura.medium.size(18),
////        NSAttributedString.Key.foregroundColor: UIColor.white,
////        NSAttributedString.Key.kern : 10.0]    
//        let itemNew = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_simple_add"), style: .plain, target: self, action: #selector(actionNew))
//        navigationItem.leftBarButtonItem = itemNew
//    }
//    
//    private func loadNotificationIcon() {
//        var itemNotifications: UIBarButtonItem
//        var buttonNotification: UIButton
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 27, height: 20))
//        let unreadCounter = viewModel.countNotification + viewModel.countMessage
//        let image = unreadCounter == 0 ? UIImage(named: "without_notifications") : UIImage(named: "with_notifications")
//        
//        buttonNotification = UIButton(type: .custom)
//        buttonNotification.setImage(image, for: .normal)
//        buttonNotification.frame = CGRect(x: 0, y: 0, width: 27, height: 20)
//        buttonNotification.addTarget(self, action: #selector(actionNotifications), for: .touchUpInside)
//        
//        view.addSubview(buttonNotification)
//        itemNotifications = UIBarButtonItem(customView: view)
//        navigationItem.rightBarButtonItem = itemNotifications
//    }
//    
//    private func makeTitleView() -> UIView {
//        let container = UIView(frame: CGRect(x: 0, y: 20, width: 80, height: 35))
//        let titleLabel = LogoLabel()
//
//        //titleLabel.drawText(in
//        container.addSubview(titleLabel)
//        let attrText = NSAttributedString(string: "ramble", attributes: [
//            NSAttributedString.Key.font: Fonts.Futura.medium.size(28),
//            NSAttributedString.Key.foregroundColor: UIColor.white,
//            NSAttributedString.Key.kern : -1.0])
//
//        titleLabel.attributedText = attrText
//        titleLabel.sizeToFit()
//        return container
//    }
//    
//    private func setupTableView() {
//        tableView.registerNib(cellClass: EventCell.self)
//        tableView.registerNib(cellClass: HomeEventCell.self)
//        tableView.registerNib(cellClass: HomeEmptyCell.self)
////        automaticallyAdjustsScrollViewInsets = false
//        tableView.contentInsetAdjustmentBehavior = .never
//        if #available(iOS 10.0, *){
//            tableView.refreshControl = refresher}
//        else{
//            tableView.addSubview(refresher)
//        }
//        tableView.tableFooterView = spinner
//    }
//    
//    @objc private func actionRefresh() {
//        spinner.startAnimating()
//        viewModel.loadEvents(isRefreshing: true)
//        viewModel.seeIfEventExist()
//        viewModel.fetchUnreadNotification()
//    }
//    
//    @objc private func actionNew() {
//     let storyboard : UIStoryboard = UIStoryboard(name: "PromoterApp", bundle: nil)
//     let popOverController = storyboard.instantiateViewController(withIdentifier: "PopPromoterController")
//        present(popOverController, animated: true)
/////===Currently Block creating the new Event===
////        if User.current() == nil {
////            blockGuest()
////        } else {
////            navigationController?.pushViewController(NewEventController(), animated: true)
////        }
/////  =================================
//    }
//    
//    @objc private func actionNotifications() {
//        if User.current() == nil {
//            blockGuest()
//        } else {    navigationController?.pushViewController(MessageController(), animated: true)
//        }
//    }
//}
//
//// MARK: - HomeViewModelDelegate
//extension HomeController: HomeViewModelDelegate {
//    
//    func didSetNotification() {
//        loadNotificationIcon()
//    }
//    
//    func didLoadData() {
//        stopLoading()
//        endRefresher(refresher: refresher)
//        tableView.reloadData()
//    }
//    
//    func didLoadDataEmpty() {
//        stopLoading()
//        spinner.stopAnimating()
//        endRefresher(refresher: refresher)
//        tableView.beginUpdates()
//        tableView.endUpdates()
//    }
//    
//    func didFail(error: String) {
//        endRefresher(refresher: refresher)
//        stopLoading { [weak self] in
//            self?.showError(err: error)
//        }
//    }
//    
//    func didSuccess(msg: String) {
//        stopLoading { [weak self] in
//            self?.showSuccess(success: msg)
//        }
//    }
//}
//
//// MARK: - HomeDataSourceDelegate
//extension HomeController: HomeDataSourceDelegate {
//    
//    func didTapSeeEventDetails(eventDetailsViewModel: EventDetailsViewModel) {
//        navigationController?.pushViewController(EventDetailsController(viewModel: eventDetailsViewModel),
//                                                 animated: true)
//    }
//    
//    func tableViewDidReachBottom() {
//        spinner.startAnimating()
//        viewModel.loadEvents(isSkipping: true)
//        viewModel.seeIfEventExist()
//    }
//    
//    func didTapSeeFilter() {
//        let filter = FilterController(pageType: "Home")
//        filter.delegate = self
//        navigationController?.pushViewController(filter, animated: true)
//    }
//}
//
//// MARK: - ButtonSectionDelegate
//extension HomeController: FilterControllerDelegate {
//    func didUpdateFilter() {
//        showLoading()
//        viewModel.loadEvents()
//        viewModel.seeIfEventExist()
//    }
//}
//
//extension HomeController {
//    private func showToolTipCreateEvent() {
//        var preferences = EasyTipView.globalPreferences
//        preferences.drawing.arrowPosition = .top
//        
//        if let createView = navigationItem.leftBarButtonItem?.view {
//            EasyTipView.show(forView: createView,
//                             withinSuperview: self.navigationController?.view,
//                             text: "Create your own event".localized,
//                             preferences: preferences,
//                             delegate: self)
//        }
//    }
//    
//    private func showToolTipFilter() {
//        var preferences = EasyTipView.globalPreferences
//        preferences.drawing.arrowPosition = .top
//
//        EasyTipView.show(forView: easyToolTipPointView,
//                         withinSuperview: self.view,
//                         text: "Use filters to indicate your preferences".localized,
//                         preferences: preferences,
//                         delegate: nil)
//    }
//}
//
//// MARK: - EasyTipViewDelegate
//extension HomeController: EasyTipViewDelegate {
//    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
//        
//        if UserDefaults.shouldShowToolTip(for: .filter) {
//            showToolTipFilter()
//        }
//    }
//}
//
//// MARK: - UITabBarControllerDelegate
//extension HomeController: UITabBarControllerDelegate {
//
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        
//        guard let navigationSelf = navigationController, let selectedTabbar = tabBarController.selectedViewController else { return true }
//        
//        if viewController.isEqual(navigationSelf) && selectedTabbar.isEqual(viewController) {
//            tableView.scrollToTop(animated: true)
//        }
//        return true
//    }
//}
//
//extension HomeController {
//    static var instance: HomeController {
//        guard let vc = Storyboard.Home.viewController(for: .home) as? HomeController else {
//            assertionFailure("Something wrong while instantiating HomeController")
//            return HomeController()
//        }
//        return vc
//    }
//}
