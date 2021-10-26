//
//  MessageManager.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-04-13.
//  Copyright © 2020 MessageKit. All rights reserved.
//
import Foundation
import CoreLocation
import MessageKit
import AVFoundation

internal struct MockMessage: MessageType {

    var messageId: String = "Default String"
    var sender: SenderType {
        return mockUser
    }
    var sentDate: Date = Date()
    var kind: MessageKind = .text(" ")
    var mockUser: MockUser = MockUser(senderId: " ", displayName: " ")
    var post: Post
//=============Override initializer=======================
    init(post: Post) {
        self.post = post
          mockUser = MockUser(senderId: post.source?.objectId ?? "Undefined", displayName: post.source!.name ?? post.source!.organizationName!)
          messageId = post.objectId!
          sentDate = post.createdAt!
          kind = .text(post.content!)
    }
//=============Original initializer====================
//    private init(kind: MessageKind, user: User, messageId: String, date: Date) {
//        self.kind = kind
//        self.messageId = messageId
//        self.sentDate = date
//        self.mockUser = MockUser(senderId: " ", displayName: " ")
          
//    }
    
//    init(text: String, user: User, messageId: String, date: Date) {
//        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
//    }
    
//    init(custom: Any?, user: MockUser, messageId: String, date: Date) {
//        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date)
//    }
//
//    init(attributedText: NSAttributedString, user: MockUser, messageId: String, date: Date) {
//        self.init(kind: .attributedText(attributedText), user: user, messageId: messageId, date: date)
//    }
//
//    init(image: UIImage, user: User, messageId: String, date: Date) {
//        let mediaItem = ImageMediaItem(image: image)
//        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date)
//    }
//
//    init(thumbnail: UIImage, user: MockUser, messageId: String, date: Date) {
//        let mediaItem = ImageMediaItem(image: thumbnail)
//        self.init(kind: .video(mediaItem), user: user, messageId: messageId, date: date)
//    }
//
//    init(location: CLLocation, user: MockUser, messageId: String, date: Date) {
//        let locationItem = CoordinateItem(location: location)
//        self.init(kind: .location(locationItem), user: user, messageId: messageId, date: date)
//    }
//
//    init(emoji: String, user: MockUser, messageId: String, date: Date) {
//        self.init(kind: .emoji(emoji), user: user, messageId: messageId, date: date)
//    }
//
//    init(audioURL: URL, user: MockUser, messageId: String, date: Date) {
//        let audioItem = MockAudiotem(url: audioURL)
//        self.init(kind: .audio(audioItem), user: user, messageId: messageId, date: date)
//    }
//
//    init(contact: MockContactItem, user: MockUser, messageId: String, date: Date) {
//        self.init(kind: .contact(contact), user: user, messageId: messageId, date: date)
//    }
//=====================================================

}

//private struct CoordinateItem: LocationItem {
//
//    var location: CLLocation
//    var size: CGSize
//
//    init(location: CLLocation) {
//        self.location = location
//        self.size = CGSize(width: 240, height: 240)
//    }
//
//}

//private struct ImageMediaItem: MediaItem {
//
//    var url: URL?
//    var image: UIImage?
//    var placeholderImage: UIImage
//    var size: CGSize
//
//    init(image: UIImage) {
//        self.image = image
//        self.size = CGSize(width: 240, height: 240)
//        self.placeholderImage = UIImage()
//    }
//
//}

//private struct MockAudiotem: AudioItem {
//
//    var url: URL
//    var size: CGSize
//    var duration: Float
//
//    init(url: URL) {
//        self.url = url
//        self.size = CGSize(width: 160, height: 35)
//        // compute duration
//        let audioAsset = AVURLAsset(url: url)
//        self.duration = Float(CMTimeGetSeconds(audioAsset.duration))
//    }
//
//}

struct MockContactItem: ContactItem {

    var displayName: String
    var initials: String
    var phoneNumbers: [String]
    var emails: [String]

    init(name: String, initials: String, phoneNumbers: [String] = [], emails: [String] = []) {
        self.displayName = name
        self.initials = initials
        self.phoneNumbers = phoneNumbers
        self.emails = emails
    }

}
