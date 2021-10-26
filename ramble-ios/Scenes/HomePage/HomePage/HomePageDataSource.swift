//
//  HomePageDataSource.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-05-31.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol HomePageDataSourceDelegate: class {
    func didTapSeeEventDetails(expDetailViewModel: ExpDetailViewModel)
    func didTapSeeAllButton(category: String)
    func changeTitleOpaque(value: CGFloat)
    func didTapBeCreatorButton()
}

class HomePageDataSource: NSObject{
    
    private var viewModel: HomePageViewModel
    weak var delegate: HomePageDataSourceDelegate?
    
    init(viewModel: HomePageViewModel, delegate: HomePageDataSourceDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    func inject(viewModel: HomePageViewModel) {
        self.viewModel = viewModel
    }
}

extension HomePageDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.typeCell(for: IndexPath(row: 0, section: section)) {
        case .header: return 0.0
        case .filter:
            if viewModel.locationAuthorization == false && viewModel.coordinate == nil{
                return 0.0
            }
            return ButtonSection.kHeight
        case .tastebuds, .entertainment, .family, .outdoors, .peopleGatherings, .artsCulture: return CatogorySection.kHeight
        case .empty: return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.typeCell(for: indexPath) {
        case .filter: return 0
        case .header: return HeaderContainer.kHeight
        case .tastebuds, .entertainment, .family, .outdoors, .peopleGatherings, .artsCulture: return EventCollectionViewCell.kHeight
        case .empty: return HomePageEmptyCell.kHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.typeCell(for: indexPath) {
        case .header:
            let cell = tableView.dequeue(cellClass: HeaderContainer.self, indexPath: indexPath)
            cell.configure(withEvents: viewModel.headerEvents, delegate: self.delegate!)
            return cell
        case .filter:
            return UITableViewCell()
            
        case .tastebuds(title: let title), .entertainment(title: let title), .family(title: let title), .outdoors(title: let title), .peopleGatherings(title: let title), .artsCulture(title: let title):
            
            let cell = tableView.dequeue(cellClass: EventsGroupViewCell.self, indexPath: indexPath)
            
            cell.configure(with: viewModel.expCategoryDict[title] ?? [], delegate: self.delegate!)
            return cell
            
        case .empty:
            let city = (viewModel.userLocation?.getCity().localized) ?? "Montreal"
            let cell = tableView.dequeue(cellClass: HomePageEmptyCell.self, indexPath: indexPath)
            if viewModel.locationAuthorization == false && viewModel.coordinate == nil{
                 cell.configure(forTitle: "Please choose a city or grant access to location service", forSubTitle: "", delegate: self)
            } else{
                 cell.configure(forTitle: "be_first_creator".localized, forSubTitle: city, delegate: self)}
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.typeCell(for: IndexPath(row: 0, section: section)) {
        case .header:
            return nil
        case .tastebuds(title: let title), .entertainment(title: let title), .family(title: let title), .outdoors(title: let title), .peopleGatherings(title: let title), .artsCulture(title: let title):
            
            let headerView = CatogorySection.fromNib()
            headerView.configure(with: title, delegate: self)
            return headerView
        case .filter:
            let headerView = ButtonSection.fromNib()
            //====should add the API to find the city=====
            headerView.configure(with: (viewModel.userLocation?.getCity().localized) ?? viewModel.city ?? "Montreal", downArrow: false, buttonHide:true, delegate: self)
            headerView.setupLabelTap()
            return headerView
        case .empty: return nil
        }
    }
}

extension HomePageDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 190.0
        {
            self.delegate?.changeTitleOpaque(value: scrollView.contentOffset.y)
        }
    }
}

extension HomePageDataSource: ButtonSectionDelegate{
    func didTapAction() {
        print("tap action")
    } 
    func didTapLabel() {
        print("tap label")
    }
}

extension HomePageDataSource: EmptyCellDelegate{
    func didTapBeCreator() {
        delegate?.didTapBeCreatorButton()
    }
}

extension HomePageDataSource: CatogorySectionDelegate{
    func didTapSeeAll(category: String) {
        delegate?.didTapSeeAllButton(category: category)
    }
}
