//
//  BandType.swift
//  ramble-ios
//
//  Created by Ramble Technologies Inc. on 2018-08-31.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

enum BandType: Int {
    case green, gold, platinum, black
    
    private func colors() -> [UIColor] {
        switch self {
        case .green: return [UIColor.AppColors.Band.green1,
                             UIColor.AppColors.Band.green2]
        case .gold: return [UIColor.AppColors.Band.gold1,
                            UIColor.AppColors.Band.gold2]
        case .platinum: return [UIColor.AppColors.Band.platinum1,
                                UIColor.AppColors.Band.platinum2]
        case .black: return [UIColor.AppColors.Band.black1,
                             UIColor.AppColors.Band.black2]
        }
    }
    
    func name() -> String {
        switch self {
        case .green: return "Green".localized
        case .gold: return "Gold".localized
        case .platinum: return "Platinum".localized
        case .black: return "Black".localized
        }
    }
    
    func eventRequired() -> Int {
        switch self {
        case .green: return 0
        case .gold: return 20
        case .platinum: return 50
        case .black: return 100
        }
    }
    
    func bandRing(for frame: CGRect, and ringWidth: CGFloat) -> UIView {
        let band = UIView(frame: frame)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = self.colors().map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0+(ringWidth/frame.width), y: 0.5)
        gradient.endPoint = CGPoint(x: 1-(ringWidth/frame.width), y: 0.5)
        band.layer.insertSublayer(gradient, at: 0)
        
        band.layer.cornerRadius = band.frame.height/2
        band.clipsToBounds = true
        
        return band
    }
    
    static func bandType(by numberOfEvents: Int) -> BandType {
        if numberOfEvents < 20 { return .green }
        if numberOfEvents < 50 { return .gold }
        if numberOfEvents < 100 { return .platinum }
        return .black
    }
}
