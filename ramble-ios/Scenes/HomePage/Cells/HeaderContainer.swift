//
//  HeaderContainer.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-06-05.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit
enum HeaderContainerType {
    case homePage
    case expDetail
}

class HeaderContainer: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageView: UIPageControl!
    
    weak var delegate: HomePageDataSourceDelegate?
    
    var type: HeaderContainerType?
    
    var events: [Event] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    var eventViewModel: ExpDetailViewModel? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView.registerNib(cellClass: HomePageTopCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
    func configure(withEvents events: [Event], delegate: HomePageDataSourceDelegate) {
        self.events = events
        self.delegate = delegate
        type = .homePage
        pageView.numberOfPages = events.count
        pageView.currentPage = 0
    }
    
    func configure(withEvent event: ExpDetailViewModel) {
        pageView.isHidden = true
        type = .expDetail
        eventViewModel = event
        pageView.currentPage = 0
    }
    
}
extension HeaderContainer {
    static var kHeight: CGFloat { return 350.0 }
}

extension HeaderContainer: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .homePage:
            return events.count
        case.expDetail:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageTopCell", for: indexPath) as! HomePageTopCell
        switch type {
        case .homePage:
            cell.configure(with: EventViewModel(event: events[indexPath.row]))
        case.expDetail:
            cell.configure(with: eventViewModel)
        default:
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.type == .homePage {
        let expDetailViewModel = ExpDetailViewModel(event: events[indexPath.row])
            delegate?.didTapSeeEventDetails(expDetailViewModel: expDetailViewModel)}
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageView.currentPage = indexPath.row
    }
    
}

extension HeaderContainer: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: HomePageTopCell.kHeight)
    }
}
