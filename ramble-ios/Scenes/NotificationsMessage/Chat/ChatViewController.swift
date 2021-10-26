//
//  ChatViewController.swift
//  ChatExample
//
//  Created by Hexiao Zhang on 2020-04-17.
//  Copyright © 2020 Ramble Technology. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Parse
import ParseLiveQuery

/// A base class for the example controllers
class ChatViewController: MessagesViewController, MessagesDataSource {
    
    var message: Message?
    var postLastLoaded: Post?
    var numberOfLoadedPost: Int?
    var liveQuery: PFQuery<Post>?
    var refreshControl = UIRefreshControl()
    private var observerQuit: NSObjectProtocol!
    private var observerEnter: NSObjectProtocol!
    
    public init(message: Message) {
        super.init(nibName: nil, bundle: nil)
        self.message = message
        
        observerQuit = NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil, queue: OperationQueue.main, using: { (notification) in
                MockSocket.shared.disconnectChat(with: self.liveQuery!)
                print("Chat obserber leave")
            })
        
        observerEnter = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil, queue: OperationQueue.main, using: { (notification) in
                self.loadAllData()
                print("Chat obserber enter")
            })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// The `BasicAudioController` controll the AVAudioPlayer state (play, pause, stop) and udpate audio cell UI accordingly.
    
    var messageList: [MockMessage] = []
    
    var posts: [Post] = []
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageCollectionView()
        configureMessageInputBar()
        liveQuery = MockSocket.shared.getQuery(message: self.message!, postBefore: nil)
        configureNavbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        clearnUnread()
        loadAllData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearnUnread()
        MockSocket.shared.disconnectChat(with: liveQuery!)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observerQuit, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(observerEnter, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func loadAllData(){
        loadFirstMessages()
        //===set livequery===
        subscribeToUpdates(query: self.liveQuery!)
        //==================
    }
    
    //========Build the livequery======
    func subscribeToUpdates(query: PFQuery<Post> ) {
        MockSocket.shared.connectChat(with: query).handle(ParseLiveQuery.Event.created) { query, object in
            if object.source !== User.current(){
                DispatchQueue.main.async {
                let messageToInsert = MockMessage.init(post: object)
                self.insertMessage(messageToInsert)
                    self.messagesCollectionView.scrollToBottom(animated: true)}}
        }
    }
    //===============================================
    private func clearnUnread(){
        if self.message?.firstUser == User.current()
        {
            self.message?.unreadFirst = 0
        } else {
            self.message?.unreadSecond = 0
        }
        if self.message?.lastPost != nil{
            self.message?.saveInBackground()}
    }
    
    @objc func setBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureNavbar(){
        let navbarProfile = NavbarProfile(frame: CGRect(x: 30, y: 0, width: 250, height: 40))
        if self.message?.firstUser == User.current()
        {
            navbarProfile.configure(with: message!.secondUser!)
        } else {
            navbarProfile.configure(with: message!.firstUser!)
        }
        let backButton = UIButton(frame: CGRect.init(x: 0, y: 10, width: 20, height: 20))
        backButton.setImage(UIImage(#imageLiteral(resourceName: "ic_back")), for: .normal)
        backButton.backgroundColor = UIColor.clear
        backButton.addTarget(self, action: #selector(self.setBack), for: .touchUpInside)
        let leftItem = UIView(frame: CGRect.init(x: 0, y: 0, width: 180, height: 40))
        leftItem.backgroundColor = UIColor.clear
        leftItem.addSubview(backButton)
        leftItem.addSubview(navbarProfile)
        let leftBarButton = UIBarButtonItem(customView: leftItem)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func loadFirstMessages() {
        DispatchQueue.global(qos: .userInitiated).async {
            MockSocket.shared.load(message: self.message!, postBefore: nil, skip: nil) { [weak self] (posts, error) in
                if error != nil {
                    self?.showError(err: error!)
                    return
                }
                DispatchQueue.main.async {
                    self?.posts = posts
                    self?.postLastLoaded = posts.first
                    self?.messageList = posts.enumerated().map
                        { (arg: (offset: Int, post: Post)) -> MockMessage? in
                            let (_, post) = arg
                            return MockMessage.init(post: post)
                    }.compactMap{ $0 }
                    self?.numberOfLoadedPost = self?.messageList.count
                    self?.messagesCollectionView.reloadData()
                    self?.messagesCollectionView.scrollToBottom()
                }
            }
        }
    }
    
    @objc
    func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            print("Load message")
            MockSocket.shared.load(message: self.message!, postBefore: self.postLastLoaded, skip: self.numberOfLoadedPost) { [weak self] (posts, error) in
                if error != nil {
                    self?.showError(err: error!)
                    return
                }
                self?.posts.insert(contentsOf: posts, at: 0)
                let insertMessageList = posts.enumerated().map
                { (arg: (offset: Int, post: Post)) -> MockMessage? in
                    let (_, post) = arg
                    return MockMessage.init(post: post)
                }.compactMap{ $0 }
                DispatchQueue.main.async {
                    self?.postLastLoaded = posts.first
                    self?.messageList.insert(contentsOf: insertMessageList, at: 0)
                    self?.numberOfLoadedPost = self?.messageList.count
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @objc private func actionRefresh() {
        loadMoreMessages()
    }
    
    func configureMessageCollectionView() {
        
        messagesCollectionView.backgroundColor = UIColor.AppColors.background
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        for subview in messageInputBar.subviews
        {
            subview.backgroundColor = UIColor.AppColors.background
            
        }
        messageInputBar.inputTextView.keyboardAppearance = UIKeyboardAppearance.dark
        messageInputBar.inputTextView.tintColor = .white
        messageInputBar.inputTextView.textColor = .white
        messageInputBar.inputTextView.cornerRadius = 13.0
        messageInputBar.inputTextView.backgroundColor = UIColor.AppColors.backgroundSender
        messageInputBar.sendButton.setTitleColor(.white, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.primaryColor.withAlphaComponent(0.3),
            for: .highlighted
        )
    }
    
    // MARK: - Helpers
    
    func insertMessage(_ message: MockMessage) {
        messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    // MARK: - MessagesDataSource
    
    func currentSender() -> SenderType {
        
        let mockuserCurrent = MockUser(senderId: User.current()?.objectId ?? "Undefined", displayName: (User.current()?.name ?? User.current()?.organizationName) ??  "Undfeind")
        return mockuserCurrent
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            
            if indexPath.section == 0  {
                let introString = NSMutableAttributedString(string: "")
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                let attrsBold = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraphStyle]
                let attrsNormal = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraphStyle]
                let name = NSAttributedString(string: self.message?.event?.owner?.organizationName ?? "undefined", attributes: attrsBold)
                let eventName = NSAttributedString(string: self.message?.event?.name ?? "Undefined", attributes: attrsBold)
                let middleString = NSAttributedString(string: " is your host for ", attributes: attrsNormal)
                introString.append(name)
                introString.append(middleString)
                introString.append(eventName)
                return introString
            } else {
                return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.white])}
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1),
                                                             NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = TimeConvert.denoteSendDate(message.sentDate)
        
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

// MARK: - MessageInputBarDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            for component in components  {
                if let str = component as? String {
                    let postCreate  = MockSocket.shared.getPost(content: str, messageBelongTo: self.message!)
                    MockSocket.shared.saveAndUpdateText(textMesaage: postCreate, message: self.message!) { [weak self] (post, error) in
                        if error == nil {
                            let messageToInsert = MockMessage.init(post: post)
                            self!.insertMessage(messageToInsert)
                            self?.messageInputBar.sendButton.stopAnimating()
                            self?.messageInputBar.inputTextView.placeholder = "Message..."
                            //                self?.insertMessages(components)
                            self?.messagesCollectionView.scrollToBottom(animated: true)} else{
                            self?.showError(err: "Something wrong, try again")
                        }
                    }
                }//end of if-let
            }//end of loop
        }//end of dispatchQueue
    }
    
    //Keep the function of sending image, may change in the future.
    //    private func insertMessages(_ data: [Any]) {
    //        for component in data {
    ////            let user = SampleData.shared.currentSender
    //            let user = User.current()
    //            if let str = component as? String {
    //                let message = MockMessage(text: str, user: user!, messageId: UUID().uuidString, date: Date())
    //                insertMessage(message)
    //            } else if let img = component as? UIImage {
    //                let message = MockMessage(image: img, user: user!, messageId: UUID().uuidString, date: Date())
    //                insertMessage(message)
    //            }
    //        }
    //    }
}

extension ChatViewController{
    
    func showError(err: String) {
        let alert = UIAlertController(title: "Sorry...", message: err, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            alert.dismiss(animated: true)
        }
        ))
        self.present(alert, animated: true, completion: nil)
    }}

// MARK: - MessageCellDelegate

extension ChatViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        print("Image tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }
    
    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }
    
    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
    
}

// MARK: - MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }
    
    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }
    
    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }
    
}
