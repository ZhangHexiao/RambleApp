//
//  OrderCell.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-07-23.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var subTotalPlaceHolder: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var serviceFeeLabel: UILabel!
    @IBOutlet weak var taxes: UILabel!
    @IBOutlet weak var stackView: UIStackView!
      
    override func awakeFromNib() {
        super.awakeFromNib()
        subTotalPlaceHolder.text = "Subtotal".localized
        // Initialization code
    }

    func configure(with viewModel: OrderViewModel?) {
        guard let viewModel = viewModel else { return }
        serviceFeeLabel.text = viewModel.serviceFeeFormatted
        subTotalLabel.text = viewModel.subtotalFormatted
        taxes.text = viewModel.taxesFormatted
        totalLabel.text = viewModel.totalFormatted
        
        clearStackViews()
        
        for item in viewModel.tickets {
            let stack = createStackView(ticketLabel: createTicketLabel(quantity: item.quantity, title: item.name),
                                        pricelLabel: createPriceLabel(price: item.orderPrice)
            )
            stackView.addArrangedSubview(stack)
        }
    }
    
}

// MARK: - OrderCell
extension OrderCell {
    
    private func clearStackViews() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    private func createStackView(ticketLabel: UILabel, pricelLabel: UILabel) -> UIStackView {
        let rect = CGRect(x: 0, y: 0, width: stackView.frame.width, height: 30)
        let stack = UIStackView(frame: rect)
        stack.spacing = 5
        stack.axis = .horizontal
        
        stack.addArrangedSubview(ticketLabel)
        stack.addArrangedSubview(pricelLabel)
        return stack
    }
    
    private func createTicketLabel(quantity: String, title: String) -> UILabel {
        let label = createLabel()
        label.text = "\(quantity) x \(title)"
        return label
    }
    
    private func createPriceLabel(price: String) -> UILabel {
        let label = createLabel()
        label.text = "\(price)"
        return label
    }
    
    private func createLabel() -> UILabel {
        let rect = CGRect(x: 0, y: 0, width: stackView.frame.width / 2, height: 30)
        let label = UILabel(frame: rect)
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        // Set Height Constraint
        let height = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        height.isActive = true
        label.addConstraint(height)
        
        // Layout
        label.font = Fonts.HelveticaNeue.medium.size(18)
        label.textColor = .white
        return label
    }
}
