//
//  HostInfoCell.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-11.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol HostInfoCellDelegate: class {
    func didTapContact()
}

class HostInfoCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var hostName: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBAction func contactButton(_ sender: Any) {
        delegate?.didTapContact()
    }
    
    weak var delegate: HostInfoCellDelegate?
    var buyTickets: Bool = false
    
    func configure(with viewModel: EventViewModel, delegate: HostInfoCellDelegate, buyTickets: Bool? = false) {
        profileImage.image = viewModel.ownerImage ?? #imageLiteral(resourceName: "ic_user_tab_selected")
        hostName.text = viewModel.ownerName
        self.buyTickets = buyTickets ?? false
        contactButton.isHidden = !self.buyTickets
        self.delegate = delegate
    }
}
extension HostInfoCell {
    static var kHeight: CGFloat { return 118 }
}
