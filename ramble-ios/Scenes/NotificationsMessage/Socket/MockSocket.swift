//
//  MockSocket.swift
//  ChatExample
//
//  Created by Hexiao Zhang on 2020-04-17.
//  Copyright © 2020 Ramble Technology. All rights reserved.
//==========================================
//message.firstUser = User.current()
//message.secondUser = event.owner
//--------------------------------------
// if message.firstUser == User.current()
// {message.unreadSecond += 1
// } else {
// message.unreadFirst += 1
// }
//==========================================
import UIKit
import MessageKit
import Parse
import PromiseKit
import ParseLiveQuery

class MockSocket {
    
    static var shared = MockSocket()
    
    private var timer: Timer?
    
    private var queuedMessage: MockMessage?
    
    private var onNewMessageCode: ((MockMessage) -> Void)?
    
    private var onTypingStatusCode: (() -> Void)?
    
    private var connectedUsers: [MockUser] = []
    
    private var chatSubscription: Subscription<Post>?
    
    private var messgeListSubscription: Subscription<Message>?
    
    var liveQueryClient = ParseLiveQuery.Client()
    
    var isConnectedChat: Bool = false
    
    var isConnectedMessageList: Bool = false
    
    init() {}
     
    func connectChat(with query: PFQuery<Post>) -> Subscription<Post> {
//        disconnectChat(with: query)
        self.liveQueryClient.reconnect()
        self.isConnectedChat = true
        self.chatSubscription = self.liveQueryClient.subscribe(query)
        return self.chatSubscription!
    }

    func disconnectChat(with query: PFQuery<Post>) -> Void{
//        timer?.invalidate()
//        timer = nil
//        onTypingStatusCode = nil
//        onNewMessageCode = nil
        if let subscription = self.chatSubscription {
            self.liveQueryClient.unsubscribe(query, handler: subscription)}
//        self.liveQueryClient.disconnect()
        self.isConnectedChat = false
    }
    
    func connectMessageList(with query: PFQuery<Message>) -> Subscription<Message> {
//            disconnectMessageList(with: query)
            self.liveQueryClient.reconnect()
            self.isConnectedMessageList = true
            self.messgeListSubscription = self.liveQueryClient.subscribe(query)
            return self.messgeListSubscription!
        }

    func disconnectMessageList(with query: PFQuery<Message>) -> Void{
            if let subscription = self.messgeListSubscription{
                self.liveQueryClient.unsubscribe(query, handler: subscription)}
            self.liveQueryClient.disconnect()
            self.isConnectedMessageList = false
        }
    
    typealias ListPostsHandler = ((_ posts: [Post], _ error: String?) -> Void)?
    typealias PostErrorHandler = ((_ error: String?) -> Void)?
    typealias PostHandler = ((_ posts: Post, _ error: String?) -> Void)?
    
    func getQuery(message: Message,postBefore: Post?) -> PFQuery<Post> {
        let chatQuery = Post.chatQuery(message: message)!
        if postBefore != nil {
            chatQuery.whereKey("createdAt", lessThan: postBefore?.createdAt as Any)
        }
        return chatQuery
    }
    
    func load(message: Message, postBefore: Post?, skip: Int?, _ completion: ListPostsHandler = nil) {
        //return any posts where the current user is the source or target
        if User.current() !== nil {
            let chatQuery = getQuery(message: message, postBefore: postBefore)
            chatQuery.findObjectsInBackground {[] (results, error) in
                guard let posts = results
                    else { completion?([], nil)
                        return
                }
                let postsInOder = Array(posts.reversed())
                completion?(postsInOder, nil)
            }} else {
            replaceRootViewController(to: UINavigationController(rootViewController: ConnectionController.instance), animated: true, completion: nil)
        }
    }

    //======use Swift Promise----
    func saveAndUpdateText(textMesaage: Post, message: Message, _ completion: PostHandler = nil){
        self.savePost(post: textMesaage, message: message)
            .then{ (_) in
                self.updateMessageLastPost(message: message)
        }.done{ (message: Message) in
            let post = message.lastPost
            completion!(post!, nil)
        }.catch{ (error) in
            let post = Post()
            completion!(post, error.localizedDescription)
        }
    }
    //==Produce a Promise when saving post=====
    func savePost(post: Post, message: Message) -> Promise<Post> {
        return Promise { seal in
            post.saveInBackground( block: {(result, error) in
                if let err = error {
                    seal.reject(err)
                    return
                }
                if result == false {
                    seal.reject(RMBError.couldntSendMessage)
                    return
                }
                message.lastPost = post
                if message.isMuteCreator != true {
                    PushNotificationManager().sendPushNotification(sender: User.current(), receiver: message.event!.owner, event: message.event!, type: .receiveMessage)}
                self.addUnread(message: message)
                seal.fulfill(post)
            })
        }
    }
    //==Produce a Promise when saving post=====
    func updateMessageLastPost(message: Message) -> Promise<Message> {
        return Promise { seal in
            message.saveInBackground( block: {(result, error) in
                if let err = error {
                    seal.reject(err)
                    return
                }
                if result == false {
                    seal.reject(RMBError.couldntSendMessage)
                    return
                }
                seal.fulfill(message)
            }
            )}
    }
    //==================================
    func addUnread(message: Message){
        if message.firstUser == User.current()
        {
            message.unreadSecond += 1
        } else {
            message.unreadFirst += 1
        }
        message.isEnabled = true
        message.saveInBackground()
    }
    //==================================
    func getPost(content: String, messageBelongTo: Message) -> Post{
        let post: Post = Post()
        let source = User.current()
        var target =  messageBelongTo.firstUser
        if messageBelongTo.firstUser == User.current()
        {  target =  messageBelongTo.secondUser }
        post.content = content
        post.source = source
        post.target = target
        post.messageGroup = messageBelongTo
        post.isEnabled = true
        let groupId = self.getGroupId(user1: messageBelongTo.firstUser!, user2: messageBelongTo.secondUser!)
        post.groupId = groupId
        return post
    }
    //==================================
    func getGroupId(user1: User, user2: User) -> String {
        let id1 = user1.objectId
        let id2 = user2.objectId
        let userIds = [id1, id2]
        let sorted = userIds.sorted {$0! < $1!}
        let joined = sorted[0]! + sorted[1]!
        return joined
    }
}
