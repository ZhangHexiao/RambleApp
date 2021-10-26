//
//  HomePageController.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-05-31.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import CoreLocation

class HomePageController: BaseController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rambleTitle: UILabel!
    @IBOutlet weak var notification: UIButton!
    @IBOutlet weak var location: UIButton!
    
    
    let viewModel = HomePageViewModel()
    var dataSource: HomePageDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        checkLocationAuthorization()
        dataSource = HomePageDataSource (viewModel: viewModel, delegate: self)
        showLoading()
        //        tableView.contentInset = UIEdgeInsets(top:  -UIApplication.shared.statusBarFrame.height, left: 0, bottom: 0, right: 0)
        setupTableView()
        makeTitleView()
        addOberver()
        viewModel.loadEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUnreadNotification()
        viewModel.fetchUnreadMessage()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupTableView() {
        let dummyViewHeight = CGFloat(40)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.registerNib(cellClass: EventsGroupViewCell.self)
        tableView.registerNib(cellClass: HeaderContainer.self)
        tableView.registerNib(cellClass: HomePageEmptyCell.self)
    }
    
    private func makeTitleView(){
        let attrText = NSAttributedString(string: "ramble", attributes: [
            NSAttributedString.Key.font: Fonts.Futura.medium.size(28),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.kern : -1.0])
            rambleTitle.attributedText = attrText
    }
    // MARK: Navigation
    
    private func loadNotificationIcon() {
        location.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        notification.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        notification.imageView?.contentMode = .scaleAspectFill
        location.imageView?.contentMode = .scaleAspectFill
        let unreadCounter = viewModel.countNotification + viewModel.countMessage
        let image = unreadCounter == 0 ? UIImage(named: "Icon_bell_notification") : UIImage(named: "Icon_receive_notification")
        notification.setImage(image, for: .normal)
        
    }
    
    @objc private func actionNotifications() {
        if User.current() == nil {
            blockGuest()
        } else {    navigationController?.pushViewController(MessageController(), animated: true)
        }
    }
    
    @IBAction func tapNotificationButton(_ sender: Any) {
        actionNotifications()
    }
    
    func addOberver(){
        NotificationCenter.default.addObserver(forName: Notification.Name.updateNotificationIcon, object: nil, queue: OperationQueue.main){ (notificaion) in
            self.viewModel.fetchUnreadNotification()
            self.viewModel.fetchUnreadMessage()
        }
    }
    
    private func checkLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                viewModel.locationAuthorization = false
                if viewModel.coordinate == nil {
                    location.pulsate()
                }
            case .authorizedAlways, .authorizedWhenInUse: break
            }
        }
    } 
}

// MARK: - SearcheventViewModelDelegate
extension  HomePageController: HomePageViewModelDelegate  {
    
    func didSetNotification() {
        loadNotificationIcon()
    }
    
    func didLoadData() {
        stopLoading()
        tableView.reloadData()
    }
    
    func didLoadDataEmpty() {
        stopLoading()
        //        tableView.beginUpdates()
        //        tableView.endUpdates()
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

extension  HomePageController: HomePageDataSourceDelegate{
    
    func didTapSeeEventDetails(expDetailViewModel: ExpDetailViewModel) {
        navigationController?.pushViewController(ExpDetailController(viewModel: expDetailViewModel), animated: true)
    }
    func changeTitleOpaque(value: CGFloat){
        if value == 190 {
            notification.isHidden = true
            location.isHidden = true
        } else {
            notification.isHidden = false
            location.isHidden = false
        }
        rambleTitle.alpha = (190 - value)/150
        notification.alpha = (190 - value)/150
        location.alpha = (190 - value)/150
    }
    
    func didTapSeeAllButton(category: String){
        let expCategory = ExpCategoryController.instance
        expCategory.viewModel.categoryName = category
        //FIXME: The Converter is used to test, can be deleted afterwards
        //------------------------------------------------------------//
        let fakeCaseConverter = { () -> String in
            switch category {
            case "Tastebuds" : return "art"
            case "Entertainment" : return "music"
            case "Family" : return "sports"
            case "Outdoors" : return "food"
            case "People & Gatherings" : return "other"
            case "Arts & Culture" : return "art"
            default: return ""
            }
        }
        let fakeCase: String = fakeCaseConverter()
        expCategory.viewModel.categoryName = fakeCase
        //--------------------------------------------------------------//
        navigationController?.pushViewController(expCategory, animated: true)
    }
    
    func didTapBeCreatorButton(){
        let storyboard : UIStoryboard = UIStoryboard(name: "PromoterApp", bundle: nil)
        let popOverController = storyboard.instantiateViewController(withIdentifier: "PopPromoterController")
        present(popOverController, animated: true)
        ///===Currently Block creating the new Event===
        //        if User.current() == nil {
        //            blockGuest()
        //        } else {
        //            navigationController?.pushViewController(NewEventController(), animated: true)
        //        }
        ///  =================================
    }
}

extension HomePageController: SelectCityControllerDelegate {
    
    @IBAction func tapLocationButton(_ sender: Any) {
        let selectCity = SelectCityController.instance
        selectCity.delegate = self
        navigationController?.pushViewController(selectCity, animated: true)
    }
    
    func didSelect(coordinate: (latitude: Double, longitude: Double)?, city: String?) {
        viewModel.city = city
        viewModel.coordinate = coordinate
        viewModel.getSetLocation(coordinate:coordinate!)
        viewModel.loadEvents(coordinate: viewModel.coordinate)
    }
}

extension HomePageController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let navigationSelf = navigationController, let selectedTabbar = tabBarController.selectedViewController else { return true }
        
        if viewController.isEqual(navigationSelf) && selectedTabbar.isEqual(viewController) {
            tableView.scrollToTop(animated: true)
        }
        return true
    }
}


extension HomePageController {
    static var instance: HomePageController {
        guard let vc = Storyboard.HomePage.viewController(for: .homePage) as? HomePageController else {
            assertionFailure("Something wrong while instantiating HomeController")
            return HomePageController()
        }
        return vc
    }
}

// This part is for tap the city lable
//extension  HomePageController: ButtonSectionDelegate{
//    func didTapAction() {
//        print("tap action")
//    }
//
//    func didTapLabel() {
//        print("tap label")
//    }
//}


