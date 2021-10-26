//
//  BandController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-01.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

class BandController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bandLabel: UILabel!
    let bands: [BandType] = [.black, .platinum, .gold, .green]

    var profileImage: UIImage = #imageLiteral(resourceName: "ic_user_placeholder")
    var nbEvents: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        ImageHelper.loadImage(data: User.current()?.profileImage) { [weak self] profileImage in
            self?.profileImage = profileImage ?? #imageLiteral(resourceName: "ic_user_placeholder")
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadNavbar()
    }
    
    // MARK: Navigation
    func loadNavbar() {
        navigationController?.setBack()
        navigationItem.title = "Band".localized
    }
    
    private func setupTableView() {
        bandLabel.text = "bandMessage".localized
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: BandCell.self)
//        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

extension BandController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: BandCell.self, indexPath: indexPath)
        cell.configure(with: profileImage, band: bands[indexPath.row], currentNbEvents: nbEvents)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BandCell.kHeight
    }
}

extension BandController {
    static var instance: BandController {
        guard let vc = Storyboard.Profile.viewController(for: .band) as? BandController else {
            assertionFailure("Something wrong while instantiating BandController")
            return BandController()
        }
        return vc
    }
}
