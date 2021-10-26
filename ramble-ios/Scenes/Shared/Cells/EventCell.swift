//
//  EventCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-20.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventView: EventView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with event: Event?) {
        guard let event = event else { return }
        eventView.configure(with: EventViewModel(event: event))
    }
    
    func configure(with eventViewModel: EventViewModel?) {
        guard let eventViewModel = eventViewModel else { return }
        eventView.configure(with: eventViewModel)
    }
}

extension EventCell {
    static var kHeight: CGFloat { return 130.0 }
}
