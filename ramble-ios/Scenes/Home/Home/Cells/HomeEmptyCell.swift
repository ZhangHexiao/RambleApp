//
//  HomeEmptyCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class HomeEmptyCell: UITableViewCell {

    @IBOutlet weak var emptyLabel: UILabel!  
    
    @IBOutlet weak var subTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(forTitle titleText: String, forSubTitle subTitleText: String = "") {
        self.emptyLabel.text = titleText
        self.subTitle.text = subTitleText
    }
}

extension HomeEmptyCell {
    static var kHeight: CGFloat { return 300.0 }
}
