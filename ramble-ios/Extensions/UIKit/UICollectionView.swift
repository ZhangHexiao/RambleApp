//
//  UICollectionView.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-17.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionView {
    
    /** Shortcut: Register a cell with his Default name and identifier on the main bundle */
    func registerNib<T: UICollectionViewCell>(cellClass: T.Type) {
        self.register(UINib(nibName: T.defaultIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: T.defaultIdentifier)
    }
    
    /** Shortcut: Dequeue a cell with his default Class Name. Example: MyCustomCell.class */
    func dequeue<T: UICollectionViewCell>(cellClass: T.Type, indexPath: IndexPath) -> T {
        return self.dequeue(withIdentifier: cellClass.defaultIdentifier, indexPath: indexPath)
    }
    
    /** Dequeue a cell with automatic casting */
    private func dequeue<T: UICollectionViewCell>(withIdentifier id: String, indexPath: IndexPath) -> T {
        // swiftlint:disable:next force_cast
        return self.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! T
    }
}
