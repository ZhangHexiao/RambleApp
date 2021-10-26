//
//  PopPromoterController.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-01-10.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class PopPromoterController: UIViewController {
    
    @IBOutlet weak var popTitle: UILabel!
    @IBOutlet weak var popContent: UILabel!
    @IBOutlet weak var goAppStore: RMBButton!

    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popTitle.text = "getYourActOUtThere".localized
        popTitle.addTextSpacing(spacing:-1.1)
        popContent.text = "useCreaterApp".localized
        popContent.addTextSpacing(spacing:-1.1)
    }
    
    @IBAction func goAppStore(_ sender: UIButton) {
      if let url = URL(string: "itms-apps://itunes.apple.com/app/id1451357208"),
          UIApplication.shared.canOpenURL(url){
          UIApplication.shared.open(url, options: [:]) { (opened) in
              if(opened){
                  print("App Store Opened")
              }
          }
      } else {
          print("Can't Open URL on Simulator")
      }
    }
     
    @IBAction func closeView(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}
extension UILabel{
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: self.text!.count))
        self.attributedText = attributedString
    }
}
