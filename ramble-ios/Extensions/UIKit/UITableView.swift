//
//  UITableView.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-17.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    
    /** Shortcut: Register a cell with his Default name and identifier on the main bundle. You must have created the corresponding nib */
    func registerNib<T: UITableViewCell>(cellClass: T.Type) {
        self.register(UINib(nibName: T.defaultIdentifier, bundle: Bundle.main), forCellReuseIdentifier: T.defaultIdentifier)
    }
    
    /** Shortcut: Register a cell with his Default name and identifier on the main bundle. */
    private func registerCell<T: UITableViewCell>(cellClass: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.defaultIdentifier)
    }
    
    /** Shortcut: Dequeue a cell with his default Class Name. Example: MyCustomCell.self */
    func dequeue<T: UITableViewCell>(cellClass: T.Type, indexPath: IndexPath) -> T {
        return self.dequeue(withIdentifier: cellClass.defaultIdentifier, indexPath: indexPath)
    }
    
    /** Dequeue a cell with automatic casting */
    private func dequeue<T: UITableViewCell>(withIdentifier id: String, indexPath: IndexPath) -> T {
        // swiftlint:disable:next force_cast
        return self.dequeueReusableCell(withIdentifier: id, for: indexPath) as! T
    }
}

extension UITableView {
    
    func scrollToTop(animated: Bool) {
        
        if numberOfSections >= 1  && numberOfRows(inSection: 0) > 0 {
            let firstIndex = IndexPath(row: 0, section: 0)
            scrollToRow(at: firstIndex, at: .top, animated: true)
        } else {
            setContentOffset(CGPoint.zero, animated: animated)
        }
    }
    
    func scrollToLastItem(indexPath: IndexPath? = nil, animated: Bool, removeInset: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections - 1)
            
            if removeInset {
                self.contentInset = UIEdgeInsets.zero
            }
            
            if numberOfRows > 0 {
                
                let indexPath = indexPath != nil ? indexPath! : IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
                
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
}
