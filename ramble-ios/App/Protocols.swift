//
//  Protocols.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-04.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol Failable: class {
    func didFail(error: String, removeFromTop: Bool)
}

protocol Successable: class {
    func didSuccess(msg: String, removeFromTop: Bool)
}

protocol Loadable: class {
    func didLoadData()
}

protocol DisplayFullScreenImage: class {
    func didTapImage(_ image: UIImage?, imageView: UIImageView?)
}

protocol EmptyCardCauseFail: class {
    func emptyCardFail()
}
