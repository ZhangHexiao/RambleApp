//
//  navbarProfile.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-04-25.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class NavbarProfile: UIView, NibLoadable {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    func configure(with displayUser: User) {
        
        loadEventImages(displayUser: displayUser)
        name.text = displayUser.name ?? displayUser.organizationName!
        layoutIfNeeded()
        self.backgroundColor = UIColor.clear
    }
    
    func loadEventImages(displayUser: User) {
        ImageHelper.loadImage(data: displayUser.profileImage) { [weak self] (image) in
                if image == nil {
                self?.profileImage.image = #imageLiteral(resourceName: "ic_user_placeholder")
                } else {
                    self?.profileImage.image = image}
            }
    }
    
}
