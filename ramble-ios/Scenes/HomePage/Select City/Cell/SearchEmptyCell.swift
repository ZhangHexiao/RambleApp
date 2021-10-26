//
//  SearchEmptyCell.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-01-08.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class SearchEmptyCell: UITableViewCell {
    
    @IBOutlet weak var cantFindLabel: UILabel!
    @IBOutlet weak var searchInout: UILabel!
    @IBOutlet weak var modifyReminderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(text: String = "",searchType:String) {
        
        if searchType == "isSearch"
        {
            self.cantFindLabel.font = self.cantFindLabel.font.withSize(20)
            self.cantFindLabel.text = "Couldn't find"
            self.searchInout.font  = self.searchInout.font.withSize(20)
            self.searchInout.text = "\"" + text + "\""
            self.modifyReminderLabel.text = "Try a different spelling or keyword"
        }
        else if searchType == "notSearch"
        {   self.cantFindLabel.font = self.cantFindLabel.font.withSize(24)
            self.cantFindLabel.text = "Find experiences"
            self.searchInout.font  = self.searchInout.font.withSize(24)
            self.searchInout.text = "made for you."
            self.modifyReminderLabel.text = ""
            
        }
        else {
            self.cantFindLabel.font = self.cantFindLabel.font.withSize(20)
            self.cantFindLabel.text = "empty_events_text".localized
            self.searchInout.text = ""
            self.modifyReminderLabel.text = "empty_events_subTitle".localized
            
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
extension SearchEmptyCell {
    static var kHeight: CGFloat { return 300.0 }
}
