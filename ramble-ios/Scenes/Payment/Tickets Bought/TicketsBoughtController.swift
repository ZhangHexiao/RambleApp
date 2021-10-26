//
//  TicketsBoughtController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit
import BSStackView

class TicketsBoughtController: BaseController {
    
    @IBOutlet weak var pageIndicator: UIPageControl!
    @IBOutlet weak var eventView: EventView!
    
    @IBOutlet weak var swiperView: BSStackView!
    @IBOutlet weak var swipeLabel: UILabel!
    
    var viewModel: TicketsBoughtViewModel
   
    public init(viewModel: TicketsBoughtViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSwiperLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        loadLayout()
        
        if viewModel.numberOfPages <= 1 {
            pageIndicator.isHidden = true
            swipeLabel.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Navigation
    func loadNavbar() {
        navigationController?.setBack()
        navigationItem.title = "Tickets".localized
        
        let itemShare =  UIBarButtonItem(image: #imageLiteral(resourceName: "ic_share").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(actionShare))
        itemShare.tintColor = UIColor.AppColors.shareItem
        navigationItem.rightBarButtonItem = itemShare
    }
    
    // MARK: Layout
    
    func loadLayout() {
        eventView.configure(with: viewModel.eventView)
        
        pageIndicator.isUserInteractionEnabled = false
        pageIndicator.numberOfPages = viewModel.numberOfPages
        pageIndicator.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
        pageIndicator.currentPageIndicatorTintColor = .white
        
        // TODO: - Refactor it, maybe use a collection view for scrolling.
        if viewModel.numberOfPages > 25 {
            pageIndicator.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
        
    }
    
    private func loadSwiperLayout() {
        swiperView.swipeDirections = UISwipeGestureRecognizer.Direction(rawValue:
            UISwipeGestureRecognizer.Direction.RawValue(UInt8(UISwipeGestureRecognizer.Direction.left.rawValue) |
                UInt8(UISwipeGestureRecognizer.Direction.right.rawValue))
        )
        
        swiperView.forwardDirections = .left
        swiperView.backwardDirections = .right
        swiperView.changeAlphaOnSendAnimation = true
        
        swiperView.delegate = self
        
        swiperView.contraintsConfigurator.top = 0
        swiperView.contraintsConfigurator.bottom = 0
        swiperView.contraintsConfigurator.leading = 0
        swiperView.contraintsConfigurator.trailing = 0
        
        var ticketViews: [TicketView] = []
        
        for (iterator, viewModel) in viewModel.tickets.enumerated() {
            let ticketView = TicketView.fromNib()
            viewModel.ticketNumber = iterator + 1 // starts with 0
            ticketView.configure(viewModel: viewModel)
            
            ticketViews.append(ticketView)
        }
        swiperView.configure(with: ticketViews)
    }
    
    // MARK: - Actions
    @objc private func actionShare() {
        guard let shareImage = view.toImage() else {
            showError(err: RMBError.unknown.localizedDescription)
            return
        }
        // Set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        // so that iPads won't crash
        activityViewController.popoverPresentationController?.sourceView = view
        // present the view controller
        navigationController?.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - BSStackViewProtocol
extension TicketsBoughtController: BSStackViewProtocol {
    
    func stackView(_ stackView: BSStackView!, didSendItem item: UIView!, direction: BSStackViewItemDirection) {
    }
    
    func stackView(_ stackView: BSStackView!, willSendItem item: UIView!, direction: BSStackViewItemDirection) {
        switch direction {
        case .front:
            if viewModel.currentPage > 0 {
                viewModel.currentPage -= 1
            } else {
                viewModel.currentPage = Double(viewModel.numberOfPages) - 1
            }
        case .back:
            if viewModel.currentPage < Double(viewModel.numberOfPages) - 1 {
                viewModel.currentPage += 1
            } else {
                viewModel.currentPage = 0
            }
        }
        
        pageIndicator.currentPage = Int(viewModel.currentPage)
    }
}
