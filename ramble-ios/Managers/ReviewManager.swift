//
//  ReviewManager.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-05-07.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

class ReviewManager {
    
    typealias RiviewsHandler = ((_ review: [Review], _ error: String?) -> Void)?
    typealias RiviewHandler = ((_ review: Review, _ error: String?) -> Void)?
    typealias CountHandler = ((_ count: Int) -> Void)?
    
    func getCurrentUserReview(event: Event, _ completion: RiviewsHandler = nil) {
        let reviewQuery  = Review.getCurrentUserReview(event: event)
        reviewQuery?.findObjectsInBackground(block: { (objects, error) in
            if let err = error {
                completion?([], err.localizedDescription)
                return
            }
            guard let reviews = objects else {
                completion?([], nil)
                return
            }
            completion?(reviews, nil)
        })
    }
    
    func getAllExperienceReview(event: Event, _ completion: RiviewsHandler = nil) {
        let reviewQuery  = Review.getAllReview(event: event)
        reviewQuery?.findObjectsInBackground(block: { (objects, error) in
            if let err = error {
                completion?([], err.localizedDescription)
                return
            }
            guard let reviews = objects else {
                completion?([], nil)
                return
            }
            completion?(reviews, nil)
        })
    }
    
    func getReviewPromise(for event: Event)-> Promise<[Review]> {
        return Promise { seal in
            
            guard User.current() != nil else {
                seal.reject(RMBError.expiredSession)
                return
            }
            
            let reviewQuery  = Review.getCurrentUserReview(event: event)
            reviewQuery?.findObjectsInBackground(block: { (objects, _) in
                seal.fulfill(objects ?? [])
            })
        }
    }
    
    func saveReviewAndUpdate(review: Review, event: Event, _ completion: RiviewHandler = nil){
        self.saveReviewAsPromise(review: review).done{ (review: Review) in
            EventManager().updateAverageStar(event: event)
            completion!(review, nil)
        }.catch{ (error) in
            let review = Review()
            completion!(review, error.localizedDescription)
        }
    }
    
    func saveReviewAsPromise(review: Review)-> Promise<Review>{
        return Promise { seal in
            review.saveInBackground( block: {(result, error) in
                if let err = error {
                    seal.reject(err)
                    return
                }
                if result == false {
                    seal.reject(RMBError.couldntSendMessage)
                    return
                }
                seal.fulfill(review)
            })
        }
    }
    
    //    func saveReview(review: Review, _ completion: RiviewHandler = nil) {
    //        review.saveInBackground(){(_, error) in
    //            if let err = error {
    //                completion?(review, err.localizedDescription)
    //                return
    //            }
    //            completion?(review, nil)
    //        }
    //    }
    
}
