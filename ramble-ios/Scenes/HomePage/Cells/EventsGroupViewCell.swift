//
//  EventsGroupViewCell.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-01.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class EventsGroupViewCell: UITableViewCell {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var events: [Event] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    weak var delegate: HomePageDataSourceDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(cellClass: EventCollectionViewCell.self)
    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //        // Configure the view for the selected state
    //    }
    
    func configure(with events: [Event], delegate: HomePageDataSourceDelegate) {
        self.events = events
        self.delegate = delegate
    }
    
}

extension EventsGroupViewCell {
    static var kHeight: CGFloat { return 188.0 }
}

extension EventsGroupViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellClass: EventCollectionViewCell.self, indexPath: indexPath)
        cell.configure(with: EventViewModel(event: self.events[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let expDetailViewModel = ExpDetailViewModel(event: events[indexPath.row])
       delegate?.didTapSeeEventDetails(expDetailViewModel: expDetailViewModel)
    }
}

extension EventsGroupViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 160)
    }
}
