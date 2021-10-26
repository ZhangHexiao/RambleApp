//
//  SearchEventController.swift
//  ramble-ios
//  Hexiao Zhang
//

import UIKit
import Foundation
import Parse

class SearcheventController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var easyToolTipPointView: UIView!

    let viewModel = SearcheventViewModel()
    var dataSource: SearcheventDataSource?
    
    //    ==========Add searchbar controller===========
    let searchController = UISearchController(searchResultsController: nil)
    //    =============================================
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.delegate = self
        tableView.estimatedRowHeight = HomeExpCell.kHeight
        showLoading()
        dataSource = SearcheventDataSource(viewModel: viewModel, delegate: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        self.definesPresentationContext = true
        self.tabBarController?.delegate = self
        viewModel.nbSkip = 0
        viewModel.seeIfEventExist()
        configureSearchBar()
//      =========add obsever for the keyboard========
 
//     ==============================================
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DiscoveryAPIManager.shared.updateEvents()
        //   ====== if keep search result when back =========
//        searchController.searchBar.text = viewModel.lastSearch
        self.viewModel.loadEvents(inputText: searchController.searchBar.text ?? "",coordinate: viewModel.coordinate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.currentLocation()
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.clearSearchFilter()
        viewModel.lastSearch = ""
        searchController.searchBar.text = ""
    }
//===========Configure search bar===================
    // MARK: SearchBar
    private func configureSearchBar(){
        searchController.searchBar.delegate = self
        let searchBar = searchController.searchBar
        searchBar.tintColor = UIColor.black
        searchBar.barTintColor = UIColor.black
//  ====This searchTextField is only valid for ISO 12 or above========
//        if #available(iOS 12.0, *) {
//        searchBar.searchTextField.backgroundColor =
//        UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//        }
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
            textfield.backgroundColor = UIColor.white
        }
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        self.navigationController?.isNavigationBarHidden = false
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.showsCancelButton = true
    }
    //=======Configure keyboard responsive desing======
    
    
   //======================================================
        
    private func setupTableView() {
        tableView.registerNib(cellClass: HomeExpCell.self)
        tableView.registerNib(cellClass: EventCell.self)
        tableView.registerNib(cellClass: SearchEmptyCell.self)
//        tableView.registerNib(cellClass: HomeEventCell.self)
        tableView.registerNib(cellClass: HomeEmptyCell.self)
//        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
}

// MARK: - SearcheventViewModelDelegate
extension SearcheventController: SearcheventViewModelDelegate {
    func didLoadData() {
        stopLoading()
        tableView.reloadData()
    }
    func didLoadDataEmpty() {
        stopLoading()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    func didFail(error: String) {
        stopLoading { [weak self] in
            self?.showError(err: error)
        }
    }
    func didSuccess(msg: String) {
        stopLoading { [weak self] in
            self?.showSuccess(success: msg)
        }
    }
}

// MARK: - SearcheventDataSourceDelegate
extension SearcheventController: SearcheventDataSourceDelegate {
    
    func didTapSeeEventDetails(eventDetailsViewModel: ExpDetailViewModel) {
//        navigationController?.pushViewController(EventDetailsController(viewModel: eventDetailsViewModel),
//                                                 animated: true)
        navigationController?.pushViewController(ExpDetailController(viewModel: eventDetailsViewModel), animated: true)
    }
    
    func tableViewDidReachBottom() {
        viewModel.loadEvents(isSkipping: true, inputText:searchController.searchBar.text ?? "", coordinate: viewModel.coordinate)
        viewModel.seeIfEventExist()
    }
    
    func didTapSeeFilter() {
        let filter = FilterController(pageType: "Search")
        viewModel.testBeforeFilter = viewModel.lastSearch!
        filter.delegate = self
        navigationController?.pushViewController(filter, animated: true)
    }
    
    func didTapCityLabel() {
        let selectCity = SelectCityController.instance
        selectCity.delegateCity = self
        navigationController?.pushViewController(selectCity, animated: true)
    }
    
    func afterTapLike(indexPath: IndexPath){
        stopLoading()
        InterestedEventManager().toggleInterestedEvent(event: viewModel.eventViewModel(at: indexPath).event) { [weak self] (interestedEvent, error) in
            if error != nil {
                return
            }
            self?.viewModel.eventViewModel(at: indexPath).event.hasEventBeenInterested = interestedEvent != nil
            self?.tableView.reloadRows(at: [indexPath], with: .top)
        }
    }
    func updateOneRow(indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

// MARK: - ButtonSectionDelegate
extension SearcheventController: FilterControllerDelegate {
    func didUpdateFilter() {
        showLoading()
        searchController.searchBar.text = viewModel.testBeforeFilter
        viewModel.testBeforeFilter = ""
        viewModel.loadEvents(inputText: searchController.searchBar.text ?? "", coordinate: viewModel.coordinate)
        viewModel.seeIfEventExist()
    }
}
extension SearcheventController: ChangeCityControllerDelegate {
    func didChange(coordinate: (latitude: Double, longitude: Double)?, city: String?) {
        viewModel.coordinate = coordinate
        viewModel.loadEvents(coordinate: viewModel.coordinate)
        viewModel.getSetLocation(coordinate:coordinate!)
    }
}

// MARK: - UITabBarControllerDelegate
extension SearcheventController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let navigationSelf = navigationController, let selectedTabbar = tabBarController.selectedViewController else { return true }
        
        if viewController.isEqual(navigationSelf) && selectedTabbar.isEqual(viewController) {
            tableView.scrollToTop(animated: true)
        }else{
                  viewModel.lastSearch = ""  
        }
        return true
    }
}
//=============Add search bar==========================
// MARK: - UITabBarDelegate
extension SearcheventController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion:{ () in
//            self.viewModel.lastSearch = searchBar.text!
            self.viewModel.loadEvents(inputText: searchBar.text!,coordinate: self.viewModel.coordinate)
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.lastSearch = searchBar.text!
        viewModel.searchTimer2?.invalidate()     
        viewModel.searchTimer2 = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] (_) in
            self!.viewModel.loadEvents(inputText: searchBar.text!,coordinate: self?.viewModel.coordinate)
            self!.showLoading()
//            self!.viewModel.lastSearch = searchBar.text!
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.viewModel.loadEvents(inputText: "",coordinate: viewModel.coordinate)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar)-> Bool {
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.text = viewModel.lastSearch
        viewModel.loadEvents(inputText: searchBar.text!,coordinate: viewModel.coordinate)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
//        viewModel.lastSearch = ""
        searchController.searchBar.text = ""
        viewModel.loadEvents(inputText: searchBar.text!,coordinate: viewModel.coordinate)
    }
}
// MARK: - UISearchControllerDelegate
//extension SearcheventController: UISearchControllerDelegate
//{
//     func willDismissSearchController(_ searchController: UISearchController) {
//        viewModel.lastSearch = searchController.searchBar.text!
//        viewModel.loadEvents(inputText: searchBar.text!,coordinate: viewModel.coordinate)
//        print("will dissmiss")
//    }
//
//    func didDismissSearchController(_ searchController: UISearchController) {
//         searchController.searchBar.text = viewModel.lastSearch
//        print("did dissmiss")
//        }
//}
//===================================================
extension SearcheventController {
    static var instance: SearcheventController {
        guard let vc = Storyboard.Searchevent.viewController(for: .searchevent) as? SearcheventController else {
            assertionFailure("Something wrong while instantiating SeacheventController")
            return SearcheventController()
        }
        return vc
    }
}

