//
//  CalendarSelectionDataSource.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-07-03.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol CalendarSelectionDataSourceDelegate: class {
    func activeButton() 
}

class CalendarSelectionDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var viewModel: CalendarSelectionViewModel
    weak var delegate: CalendarSelectionDataSourceDelegate?
    
    
    init(viewModel: CalendarSelectionViewModel, delegate: CalendarSelectionDataSourceDelegate) {
         self.viewModel = viewModel
         self.delegate = delegate
     }
     
     func inject(viewModel: CalendarSelectionViewModel) {
         self.viewModel = viewModel
     }
    
}

extension CalendarSelectionDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sectionSelected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionDurationCell", for: indexPath) as! SectionDurationCell
        cell.configure(with: viewModel.sectionSelected[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.activeButton() 
    }
}

extension CalendarSelectionDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 100)
    }
}
