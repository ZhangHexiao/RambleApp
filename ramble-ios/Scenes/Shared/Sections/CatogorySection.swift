//
//  CatogorySection.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-04.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol CatogorySectionDelegate: class {
    func didTapSeeAll(category: String)
}

class CatogorySection: UIView {
    
    
    @IBOutlet weak var catogoryLable: UILabel!
    
    @IBOutlet weak var seeAllButton: UIButton!
    
    weak var delegate: CatogorySectionDelegate?
    
    var category: String = ""
    
    func configure(with title: String, delegate: CatogorySectionDelegate) {
        
          category = title
          let attributesCatogory: [NSAttributedString.Key: Any] = [
                   .font: Fonts.HelveticaNeue.bold.size(24),
                   .foregroundColor: UIColor.AppColors.cityButton
               ]
          let myString = NSMutableAttributedString(string:title + "", attributes: attributesCatogory)
          myString.addAttribute(NSAttributedString.Key.kern, value: -1.2, range: NSRange(location: 0, length: myString.length - 1))
               catogoryLable.attributedText = myString
           let attributesSeeAll: [NSAttributedString.Key: Any] = [
                 .font: Fonts.HelveticaNeue.bold.size(15),
                 .foregroundColor: UIColor.AppColors.catogoryButton
             ]
           let seeAllString = NSMutableAttributedString(string:"See all" + "", attributes:  attributesSeeAll)
           seeAllString.addAttribute(NSAttributedString.Key.kern, value: -1.0, range: NSRange(location: 0, length: seeAllString.length - 1))
           seeAllButton.setAttributedTitle(seeAllString, for: .normal)
        
           self.delegate = delegate
       }
   
    @IBAction func tapSeeAllButton(_ sender: Any) {
        delegate?.didTapSeeAll(category: category)
    }
}

extension CatogorySection {
    class func fromNib() -> CatogorySection {
        let nib = UINib(nibName: "CatogorySection", bundle: Bundle.main)
        // swiftlint:disable:next force_cast
        return nib.instantiate(withOwner: self, options: nil)[0] as! CatogorySection
    }
}

extension CatogorySection {
    static var kHeight: CGFloat { return 40 }
}
