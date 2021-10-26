//
//  RatingViewModel.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-05-08.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
enum RatingViewType {
    case setup, edit
}

protocol RatingViewModellDelegate: class {
    func didSuccess(msg: String)
    func didFail(error: String)
    func setUpEventView()
}

class RatingViewModel {
    
    var event: Event = Event()
    
    var temEvent: Event{
        set{
            event = newValue
            DispatchQueue.main.async {
                self.delegate?.setUpEventView()
            }
        }
        get{
            return event
        }
    }

    var type: RatingViewType = .setup
    
    var review: Review?
    
    var star: Int!
    
    weak var delegate: RatingViewModellDelegate?
    
    func setEvent(Id: String) {
        EventManager().getEventBaseOnId(Id: Id){ [weak self](events, error) in
                       if error == nil && events.count != 0 {
                        self?.temEvent = events.first!
                       }
                   }
    }
    
    func saveReview(){
        switch type {
        case .edit:
            self.delegate?.didFail(error: "You have already reviewed this experience")
        case .setup:
            
            if Date() > event.endAt ?? Date() {
            let review = Review()
            review.star = self.star
            review.event = self.event
            review.user = User.current()
            ReviewManager().saveReviewAndUpdate(review: review, event: self.event ){ [weak self] (review, error) in
                if error != nil {
                    self?.delegate?.didFail(error: "Something worong, try again")
                    return
                }
                self?.delegate?.didSuccess(msg: "Thanks for responding")
                return
            }
            } else {
                self.delegate?.didFail(error: "Please rate until experience ends")
            }
        }
    }
}


