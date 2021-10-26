//
//  ExpCategoryController.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-15.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//
import UIKit
import Foundation

class ExpCategoryController: BaseController {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rambleTitle: UILabel!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(actionRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    func endRefresher(refresher: UIRefreshControl){
        let stoptime = DispatchTime.now() + .milliseconds(400)
        DispatchQueue.main.asyncAfter(deadline: stoptime){
            refresher.endRefreshing()
        }
    }
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        if #available(iOS 13.0, *) {
            let spinner = UIActivityIndicatorView(style: .large)
        }
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        return spinner
    }()
    
    let viewModel = ExpCategoryViewModel()
    var dataSource: ExpCategoryDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.delegate = self
        tableView.estimatedRowHeight = HomeEventCell.kHeight
        showLoading()
        dataSource = ExpCategoryDataSource(viewModel: viewModel, delegate: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 0, right: 0)
        self.tabBarController?.delegate = self
        viewModel.nbSkip = 0
        viewModel.loadEvents()
        viewModel.seeIfEventExist()
        loadFakeNavbar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFakeNavbar()
        navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.reloadData()
        tableView.contentInsetAdjustmentBehavior = .never
//      navigationItem.titleView = makeTitleView()
        DiscoveryAPIManager.shared.updateEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func loadFakeNavbar() {
        navigationController?.setBack()
        navigationItem.titleView = nil
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let attrText = NSAttributedString(string: viewModel.categoryName, attributes: [
            NSAttributedString.Key.font: Fonts.HelveticaNeue.medium.size(23),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.kern : -1.0])
        
        rambleTitle.attributedText = attrText
    }

    
    private func setupTableView() {
        tableView.registerNib(cellClass: EventCell.self)
        tableView.registerNib(cellClass: HomeExpCell.self)
        tableView.registerNib(cellClass: HomeEmptyCell.self)
//        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 10.0, *){
            tableView.refreshControl = refresher}
        else{
            tableView.addSubview(refresher)
        }
        tableView.tableFooterView = spinner
    }
    
    @objc private func actionRefresh() {
//        spinner.startAnimating()
        viewModel.loadEvents(isRefreshing: true)
        viewModel.seeIfEventExist()
    }
    
    @objc private func actionNew() {
     let storyboard : UIStoryboard = UIStoryboard(name: "PromoterApp", bundle: nil)
     let popOverController = storyboard.instantiateViewController(withIdentifier: "PopPromoterController")
        present(popOverController, animated: true)
///===Currently Block creating the new Event===
//        if User.current() == nil {
//            blockGuest()
//        } else {
//            navigationController?.pushViewController(NewEventController(), animated: true)
//        }
///  ============================
    }
    
    @objc private func actionNotifications() {
        if User.current() == nil {
            blockGuest()
        } else {    navigationController?.pushViewController(MessageController(), animated: true)
        }
    }
}

// MARK: - HomeViewModelDelegate
extension ExpCategoryController: ExpCategoryViewModelDelegate {
    
    func didLoadData() {
        stopLoading()
        endRefresher(refresher: refresher)
        tableView.reloadData()
    }
    
    func didLoadDataEmpty() {
        stopLoading()
        spinner.stopAnimating()
        endRefresher(refresher: refresher)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func didFail(error: String) {
        endRefresher(refresher: refresher)
        stopLoading { [weak self] in
            self?.showError(err: error)
        }
    }
    
    func didSuccess(msg: String) {
        stopLoading { [weak self] in
            self?.showSuccess(success: msg)
        }
    }
}

extension ExpCategoryController: HomeExpCellDelegate {
    func afterTapLike(indexPath: IndexPath){
        stopLoading()
        InterestedEventManager().toggleInterestedEvent(event: viewModel.eventViewModel(at: indexPath).event) { [weak self] (interestedEvent, error) in
            if error != nil {
                return
            }
            self?.viewModel.eventViewModel(at: indexPath).event.hasEventBeenInterested = interestedEvent != nil
            self?.tableView.reloadRows(at: [indexPath], with: .top)
        }
    }
    func updateOneRow(indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - HomeDataSourceDelegate
extension ExpCategoryController: ExpCategoryDataSourceDelegate {
    
    func didTapSeeEventDetails(expDetailViewModel: ExpDetailViewModel) {
       navigationController?.pushViewController(ExpDetailController(viewModel: expDetailViewModel), animated: true)
    }
    
    func tableViewDidReachBottom() {
        spinner.startAnimating()
        viewModel.loadEvents(isSkipping: true)
        viewModel.seeIfEventExist()
    }
    
//    func didTapSeeFilter() {
//        let filter = FilterController(pageType: "Home")
//        filter.delegate = self
//        navigationController?.pushViewController(filter, animated: true)
//    }
}


// MARK: - UITabBarControllerDelegate
extension ExpCategoryController : UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let navigationSelf = navigationController, let selectedTabbar = tabBarController.selectedViewController else { return true }

        if viewController.isEqual(navigationSelf) && selectedTabbar.isEqual(viewController) {
            tableView.scrollToTop(animated: true)
        }
        return true
    }
}
extension ExpCategoryController {
    static var instance: ExpCategoryController {
        guard let vc = Storyboard.HomePage.viewController(for: .expCategory) as? ExpCategoryController else {
            assertionFailure("Something wrong while instantiating FriendsListController")
            return ExpCategoryController()
        }
        return vc
    }
}
