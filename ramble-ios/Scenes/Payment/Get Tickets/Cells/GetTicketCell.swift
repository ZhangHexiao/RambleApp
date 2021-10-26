//
//  GetTicketCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-20.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

protocol GetTicketCellDelegate: class {
    func didUpdateValue(viewModel: TicketViewModel, cell: UITableViewCell )
}

class GetTicketCell: UITableViewCell {
    
    @IBOutlet weak var ticketNameLabel: UILabel!
    @IBOutlet weak var ticketsLeftLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
   
    weak var delegate: GetTicketCellDelegate?
    var viewModel: TicketViewModel?
    
    func configure(with viewModel: TicketViewModel?, delegate: GetTicketCellDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        loadLayout()
    }
    
    private func loadLayout() {
        ticketNameLabel.text = viewModel?.name
        ticketsLeftLabel.text = viewModel?.ticketsLeft
        priceLabel.text = viewModel?.formattedPrice
        descriptionLabel.text = viewModel?.description
        quantityLabel.text = viewModel?.quantity
        
        if viewModel?.hasSoldout ?? true { // if we don't know, we don't show anyways
            addButton.isHidden = true
            removeButton.isHidden = true
            quantityLabel.isHidden = true
            ticketsLeftLabel.textColor = UIColor.AppColors.cancelled
        } else {
            addButton.isHidden = false
            removeButton.isHidden = false
            quantityLabel.isHidden = false
            ticketsLeftLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
    
    @IBAction func actionAdd() {
        viewModel?.add()
        
        guard let viewModel = viewModel else { return }
        delegate?.didUpdateValue(viewModel: viewModel, cell: self)
    }
    
    @IBAction func actionRemove() {
        viewModel?.remove()
        
        guard let viewModel = viewModel else { return }
        delegate?.didUpdateValue(viewModel: viewModel, cell: self)
    }
}
