//
//  MessageController.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-04-23.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class MessageController: UIViewController {
    
    @IBOutlet weak var emptyView: RMBBackgroundView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //    var groupId: String = ""
    let viewModel: NotiMesViewModel = NotiMesViewModel()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(actionRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var observerQuit: NSObjectProtocol!
    private var observerEnter: NSObjectProtocol!
    var segmentIndex: Int = 0
    
    public init(segmentIndex: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        self.segmentIndex = segmentIndex
        hidesBottomBarWhenPushed = true
        
        observerQuit = NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil, queue: OperationQueue.main, using: { (notification) in
                self.viewModel.disconnectLiveQuery()
                print("obserber leave")
            })
        
        observerEnter = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil, queue: OperationQueue.main, using: { (notification) in
               self.loadAllData()
                print("obserber enter")
            })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleView
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(actionCompose))
        if segmentIndex == 1 {
            segmentController.selectedSegmentIndex = 1
        }
        viewModel.delegateNoti = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
        loadNavbar()
        loadAllData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.disconnectLiveQuery()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
     }
    
    deinit {
        NotificationCenter.default.removeObserver(observerQuit, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(observerEnter, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func actionRefresh() {
        if segmentController.selectedSegmentIndex == 0 {
            viewModel.fetchMessage()
        } else {
            viewModel.fetchNotification()
        }
        
    }
    
    private func loadAllData() {
        viewModel.fetchMessage()
        viewModel.fetchNotification()
        tableView.reloadData()
        viewModel.subscribeToUpdates()
    }
    
    private func loadNavbar() {
        navigationController?.setBack()
        navigationItem.title = ""
        if let index = navigationController?.viewControllers.firstIndex(of: self), index == 0 {
            let itemBack = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backHomPage))
            navigationItem.leftBarButtonItem = itemBack
        }

    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: MessageCell.self)
        tableView.registerNib(cellClass: NotificationCell.self)
        tableView.addSubview(refreshControl)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        }
//        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
        let titleUnselectTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.AppColors.unSelecSeg]
        let titleSelectTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.AppColors.selecSeg]
           segmentController.setTitleTextAttributes(titleUnselectTextAttributes, for: .normal)
           segmentController.setTitleTextAttributes(titleSelectTextAttributes, for: .selected)
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        didLoadData()
    }
    
    func actionDeleteMessage(at indexPath: IndexPath) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.messages[indexPath.row].isEnabled = false
            MessagesManager().save(message: self.viewModel.messages[indexPath.row] ){ [weak self] (_, error) in
                if error != nil {
                    // Add deal with error
                    //                   self?.showError(err: error!)
                    return
                }
                DispatchQueue.main.async{
                    self?.viewModel.messages.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }

    func actionDeleteNoti(at indexPath: IndexPath) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.notifications[indexPath.row].isEnabled = false
            NotificationManager().save(notification: self.viewModel.notifications[indexPath.row]){ [weak self] (_, error) in
                if error != nil {
                    // Add deal with error
                    //                   self?.showError(err: error!)
                    return
                }
                DispatchQueue.main.async{
                    self?.viewModel.notifications.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func actionMute(at indexPath: IndexPath) {
        
        let currentStatus = self.viewModel.messages[indexPath.row].isMuteUser
        if currentStatus {
            self.viewModel.messages[indexPath.row].isMuteUser = false
        } else {
            self.viewModel.messages[indexPath.row].isMuteUser = true
        }
        
        MessagesManager().save(message: self.viewModel.messages[indexPath.row] ){ [weak self] (_, error) in
            if error != nil {
                // deal with error
                // self?.showError(err: error!)
                return
            }
            DispatchQueue.main.async{
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)}
        }
    }
    
    
    // MARK: - Actions
    @objc private func actionMarkAsRead() {
        viewModel.markAllAsRead()
    }
    @objc private func backHomPage() {
        replaceRootViewController(to: TabbarController.instance, animated: true, completion: nil)
    }
    // MARK: - Cleanup methods
    //    @objc func actionCleanup() {
    //
    //        tokenMembers?.invalidate()
    //        tokenChats?.invalidate()
    //
    //        members    = realm.objects(Member.self).filter(falsepredicate)
    //        chats    = realm.objects(Chat.self).filter(falsepredicate)
    //
    //        refreshTableView()
    //    }
}

// MARK: - UIScrollViewDelegate
extension MessageController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}


extension  MessageController: NotificationDelegate {
    func didLoadData() {
        refreshControl.endRefreshing()
        if segmentController.selectedSegmentIndex == 0 {
            navigationItem.rightBarButtonItem = nil
            emptyView.isHidden = !viewModel.isMessageEmpty
            tableView.reloadData()
            //Here add the video call function
            //Here add the video call function
        } else{
            emptyView.isHidden = !viewModel.isNotiEmpty
            tableView.reloadData()
            
            if viewModel.isNotiEmpty {
                navigationItem.rightBarButtonItem = nil
            } else {
                let itemSave = UIBarButtonItem(image: #imageLiteral(resourceName: "mark_read"), style: .plain, target: self, action: #selector(actionMarkAsRead))
                itemSave.tintColor = UIColor.AppColors.darkGray
                navigationItem.rightBarButtonItem = itemSave
            }
        }
    }
}

// MARK: - UITableViewDataSource
//--------------------------------------------
extension MessageController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentController.selectedSegmentIndex == 0 {
            return viewModel.numberOfRows(type: "message")
        } else {
            return viewModel.numberOfRows(type: "notification")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentController.selectedSegmentIndex == 0 {
            
            let cell = tableView.dequeue(cellClass: MessageCell.self, indexPath: indexPath)
            
            cell.configure(viewModel: viewModel.message(at: indexPath))
            
            return cell
            
        } else {
            let cell = tableView.dequeue(cellClass: NotificationCell.self, indexPath: indexPath)
            
            var layoutFriendCellPosition = LayoutFriendCellPosition.any
            
            if indexPath.row == 0 && indexPath.row == viewModel.numberOfRows(type: "notification") - 1 {
                layoutFriendCellPosition = .firstAndLast
            } else if indexPath.row == 0 {
                layoutFriendCellPosition = .first
            } else if indexPath.row != 0 && indexPath.row == viewModel.numberOfRows(type: "notification") - 1 {
                layoutFriendCellPosition = .last
            }
            cell.configure(viewModel: viewModel.notification(at: indexPath), position: layoutFriendCellPosition)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
       if segmentController.selectedSegmentIndex == 0 {
        
        let isMuteUser = self.viewModel.selectMessage(at: indexPath)?.isMuteUser
        let mutetitle = isMuteUser == true ? "Unmute" : "mute"
        let actionDeleteMessage = UIContextualAction(style: .destructive, title: "Delete") {  action, sourceView, completionHandler in
            self.actionDeleteMessage(at: indexPath)
            completionHandler(true)
        }
        let actionMute = UIContextualAction(style: .normal, title: mutetitle) {  action, sourceView, completionHandler in
            self.actionMute(at: indexPath)
            completionHandler(true)
        }
        
        //        actionDelete.image = #imageLiteral(resourceName: "img1")
        //        actionMore.image = #imageLiteral(resourceName: "img1")
        return UISwipeActionsConfiguration(actions: [actionDeleteMessage, actionMute])
         } else{
        
        let actionDeleteNoti = UIContextualAction(style: .destructive, title: "Delete") {  action, sourceView, completionHandler in
            self.actionDeleteNoti(at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [actionDeleteNoti])
                }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if segmentController.selectedSegmentIndex == 0 {
            if let message = viewModel.selectMessage(at: indexPath) {
                navigationController?.pushViewController(BasicExampleViewController(message: message), animated: true)
                
            }
        } else {
            if let viewModel = viewModel.selectNotificaiton(at: indexPath) {
                let eventDetails = ExpDetailController(viewModel: viewModel)
                navigationController?.pushViewController(eventDetails, animated: true)
            }
        }
    }
}

