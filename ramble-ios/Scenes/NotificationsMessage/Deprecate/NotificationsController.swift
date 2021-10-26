//
////  NotificationsController.swift
////  ramble-ios
////
////  Created by Ramble Technologies on 2018-07-17.
////  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//
//
//import UIKit
//
//class NotificationsController: BaseController {
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var emptyView: RMBBackgroundView!
//
//    let viewModel: NotificationViewModel = NotificationViewModel()
//
//    lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(actionRefresh), for: .valueChanged)
//        return refreshControl
//    }()
//
//    public init() {
//        super.init(nibName: nil, bundle: nil)
//        hidesBottomBarWhenPushed = true
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Life cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        viewModel.delegate = self
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadNavbar()
//        viewModel.fetch()
//    }
//
//    @objc private func actionRefresh() {
//        viewModel.fetch()
//    }
//
//    // MARK: Navigation
//    private func loadNavbar() {
//        navigationController?.setBack()
//        navigationItem.title = "Notifications".localized
//    }
//
//    // MARK: Layout
//    private func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.registerNib(cellClass: NotificationCell.self)
//        tableView.addSubview(refreshControl)
//        automaticallyAdjustsScrollViewInsets = false
//    }
//
//    // MARK: - Actions
//    @objc private func actionMarkAsRead() {
//        viewModel.markAllAsRead()
//    }
//}
//
//// MARK: - NotificationDelegate
//extension NotificationsController: NotificationDelegate {
//
//    func didLoadData() {
//        refreshControl.endRefreshing()
//        emptyView.isHidden = !viewModel.isEmpty
//        tableView.reloadData()
//
//        if viewModel.isEmpty {
//            navigationItem.rightBarButtonItem = nil
//        } else {
//            let itemSave = UIBarButtonItem(image: #imageLiteral(resourceName: "mark_read"), style: .plain, target: self, action: #selector(actionMarkAsRead))
//            itemSave.tintColor = UIColor.AppColors.darkGray
//            navigationItem.rightBarButtonItem = itemSave
//        }
//    }
//}
//
//// MARK: - UITableViewDelegate, UITableViewDataSource
//extension NotificationsController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfRows()
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue(cellClass: NotificationCell.self, indexPath: indexPath)
//
//        var layoutFriendCellPosition = LayoutFriendCellPosition.any
//
//        if indexPath.row == 0 && indexPath.row == viewModel.numberOfRows() - 1 {
//            layoutFriendCellPosition = .firstAndLast
//        } else if indexPath.row == 0 {
//            layoutFriendCellPosition = .first
//        } else if indexPath.row != 0 && indexPath.row == viewModel.numberOfRows() - 1 {
//            layoutFriendCellPosition = .last
//        }
//
//        cell.configure(viewModel: viewModel.notification(at: indexPath), position: layoutFriendCellPosition)
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let viewModel = viewModel.select(at: indexPath) {
//            let eventDetails = EventDetailsController(viewModel: viewModel)
//            navigationController?.pushViewController(eventDetails, animated: true)
//        }
//    }
//}
