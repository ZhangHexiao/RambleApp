//
//  NewEventCellSwitch.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-02.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol NewEventCellSwitchDelegate: class {
    func switchCellDidChange(status: Bool)
}

class NewEventCellSwitch: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isRequiredSwitch: UISwitch!
    
    weak var delegate: NewEventCellSwitchDelegate?
    
    override func awakeFromNib() {
        titleLabel.text = "Booking required".localized
    }
    
    func configure(with status: Bool, delegate: NewEventCellSwitchDelegate) {
        self.delegate = delegate
        isRequiredSwitch.isOn = status
        titleLabel.textColor = status ? .white : UIColor.AppColors.placeHolderGray
    }
    
    @IBAction func actionSwitchChanged(_ sender: UISwitch) {
        delegate?.switchCellDidChange(status: sender.isOn)
    }
}
