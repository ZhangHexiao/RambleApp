//
//  EventView.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2020-05-04.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class EventView: UIView, NibLoadable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ownerImageView: RMBRoundImage!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var countTimeLabel: UILabel!
    
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusViewWidth: NSLayoutConstraint! // 70
    
    @IBOutlet weak var isVerifiedAccount: UIImageView!
    var countdownTimer = Timer()
    var countdownDate: Date?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    func configure(with viewModel: EventViewModel?) {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.eventName
        
        if let startAt = viewModel.startAt, startAt.isWithin24Hours {
            countTimeLabel.isHidden = false
            countdownDate = startAt
            countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
            countdownTimer = Timer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
            RunLoop.main.add(countdownTimer, forMode: RunLoop.Mode.common)
            
        } else {
            countTimeLabel.isHidden = true
            countdownTimer.invalidate()
        }
        
        switch viewModel.eventStatus {
        case .active, .reported:
            cancelView.isHidden = true
            statusViewWidth.constant = 0
        
        case .blocked:
            cancelView.isHidden = false
            statusViewWidth.constant = 70
            cancelView.backgroundColor = UIColor.AppColors.blocked
            statusLabel.text = "Blocked".localized
        
        case .cancelled:
            cancelView.isHidden = false
            statusViewWidth.constant = 70
            cancelView.backgroundColor = UIColor.AppColors.cancelled
            statusLabel.text = "Cancelled".localized
        }
        layoutIfNeeded()
        
        ownerNameLabel.text = viewModel.ownerName
        dateLabel.text = viewModel.eventDateFormatted
        
        eventImageView.image = nil
        viewModel.loadCoverImage { [weak self] (image) in
            self?.eventImageView.image = image ?? nil
        }

        viewModel.loadOwnerImage { [weak self] (image) in
            self?.ownerImageView.image = image ?? #imageLiteral(resourceName: "ic_user_tab")
        }
        isVerifiedAccount.isHidden = !(viewModel.event.owner?.isVerifiedAccount ?? false)
    }
    
    @objc private func updateTime() {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        if countdownDate != nil {
            let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: countdownDate!)
            
            countTimeLabel.text = String(format: "%02d:", diffDateComponents.hour ?? 0) +
                                String(format: "%02d:", diffDateComponents.minute ?? 0) +
                                String(format: "%02d", diffDateComponents.second ?? 0)
        }
    }
}
