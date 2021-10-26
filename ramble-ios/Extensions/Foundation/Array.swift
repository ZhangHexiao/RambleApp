//
//  Array.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-10-18.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation

extension Array {
    
    /**
     Remove duplicate elements from an array given an attribute
     - parameter includeElement: block lhs and rhs
     - returns: [Element]: List of Elements
     */
    func filterDuplicates(includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}

extension Array where Element: Hashable {
    func difference(from array: [Element]) -> [Element] {
        let firstSet = Set(self)
        let otherSet = Set(array)
        return Array(firstSet.symmetricDifference(otherSet))
    }
    
    func filterDuplicates(includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}
