//
//  HomeEmptyCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol EmptyCellDelegate: class {
    func didTapBeCreator()
}

class HomePageEmptyCell: UITableViewCell {

    @IBOutlet weak var emptyLabel: UILabel!
    
    @IBOutlet weak var beCreatorButton: RMBButton!
    
    weak var delegate: EmptyCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(forTitle titleText: String, forSubTitle subTitleText: String = "", delegate: EmptyCellDelegate) {
        self.emptyLabel.text = titleText + " " + subTitleText
        self.delegate = delegate
        beCreatorButton.applyGradient(colours: [UIColor.AppColors.buttonLeftEmptyCell, UIColor.AppColors.buttonRightEmptyCell])
        beCreatorButton.clipsToBounds = true
    }
    
    @IBAction func tapBeCreatorButton(_ sender: Any) {
        delegate?.didTapBeCreator()
    }   
}

extension HomePageEmptyCell {
    static var kHeight: CGFloat { return 280.0 }
}
