//
//  TabbarController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-19.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

enum TabbarIndex: Int {
//    case home = 0
    case homePage = 0
    case searchevent = 1
    case map = 2
    case profile = 3
}

class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for controller in viewControllers ?? [] {
            controller.tabBarItem.title = nil
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = UIColor.AppColors.navBar
        
        // Add observers to add badge when app is Active
        GRNNotif.updatedProfileImage.observe(observer: self) { [weak self] (notification) in
            self?.updateProfileImage(notification.object as? UIImage)
        }
        
        // Add observers to check invalid session
        GRNNotif.invalidSession.observe(observer: self) { (notification) in
            replaceRootViewController(to: RMBNavigationController(rootViewController: SplashController.instance), animated: true, completion: nil)
        }
        
        GRNNotif.guestLoggedIn.observe(observer: self) { [weak self] _ in
            self?.loggedIn()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.pushRatingController, object: nil, queue: OperationQueue.main){ (notificaion) in
            self.navigateToRate(notification: notificaion)
        }
    }
    
    @objc private func navigateToRate(notification: Notification) {
        let Id = notification.userInfo?["eventId"]
        let ratingController = RatingViewController(Id: Id as! String)
         replaceRootViewController(to: RMBNavigationController(rootViewController: ratingController), animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if User.current() == nil {
            let controller = ConnectionController.instance
            
            (viewControllers?[3] as? RMBNavigationController)?.viewControllers = [controller]
        }
        
        updateProfileImage()
    }
    
    private func loggedIn() {
        let vc = ProfileController.instance
        let navigator = RMBNavigationController(rootViewController: vc)
        navigator.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        viewControllers?[2] = navigator
        updateProfileImage()
    }
    
    private func updateProfileImage(_ newImage: UIImage? = nil) {
        // If image is from GRNNotif we don't need to fetch again
        if let image = newImage {
            setProfileTabItem(image: image)
        } else {
            // We fetch the image from Parse User
            ImageHelper.loadImage(data: User.current()?.profileImage) { [weak self] image in
                self?.setProfileTabItem(image: image)
            }
        }
    }
    
    private func setProfileTabItem(image: UIImage?) {
        
        let tabItems = tabBar.items as NSArray?
        let tabItem = tabItems?[TabbarIndex.profile.rawValue] as? UITabBarItem
        
        let roundImage = image?.circularImage(width: 26)
        tabItem?.image = roundImage?.withRenderingMode(.alwaysOriginal) ?? #imageLiteral(resourceName: "ic_user_tab")
        
        let roundBorderedImage = roundImage?.addBorder(width: 1.5, color: .lightGray)
        tabItem?.selectedImage = roundBorderedImage?.withRenderingMode(.alwaysOriginal) ?? #imageLiteral(resourceName: "ic_user_tab_selected")
    }
}

extension TabbarController {
    public static var instance: TabbarController {
        guard let vc = Storyboard.Main.viewController(for: .tabbar) as? TabbarController else {
            assertionFailure("Something wrong while instantiating TabbarController")
            return TabbarController()
        }
        return vc
    }
}
