//
//  CalendarSelectionViewModel.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-07-03.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation

protocol CalendarSelectionViewModelDelegate: class {
    func didLoadData()
    func didFail(error: String, removeFromTop: Bool)
    func didSuccess(msg: String, removeFromTop: Bool)
}

class CalendarSelectionViewModel {
    
    var expDetailViewModel: ExpDetailViewModel
    weak var delegate: CalendarSelectionViewModelDelegate?
    var ticketsDict: [String: [TicketViewModel]] = [:]
//    var datesSelectString: [String] = ["07-03-2020", "07-04-2020", "07-05-2020"]
    var datesSelectString: [String] = []
    var sectionSelected: [TicketViewModel] = [] {
        didSet{
            delegate?.didLoadData()
        }
    }
    
    init(viewModel: ExpDetailViewModel, calendarSelection: CalendarSelectionViewModelDelegate) {
        expDetailViewModel = viewModel
        delegate = calendarSelection
    }
    
    func loadData() {
        let group = DispatchGroup()
        group.enter()
        TicketManager().all(for: expDetailViewModel.eventViewModel.event) { [weak self] (tickets, error) in
            if let err = error {
                self?.delegate?.didFail(error: err, removeFromTop: true)
                return
            }
//            self?.tickets = tickets.map { TicketViewModel(ticket: $0) }
            for ticket in tickets {
                let sectionDate = ticket.startAt ?? Date()
                let key = RMBDateFormat.mdySimple.formatted(date: sectionDate)
                var arr = self?.ticketsDict[key]
                if arr == nil {
                    arr = [TicketViewModel(ticket: ticket)]
                    self?.datesSelectString.append(key)
                } else {
                    arr?.append(TicketViewModel(ticket: ticket))
//                    arr = arr?.sorted(by: {
//                        return ($0.startAt?.absoluteDaysDifference(from: $1.startAt ?? Date()))! < 0
//                    })
                }
                self?.ticketsDict[key] = arr
                
            }
            group.leave()
            group.notify(queue: .main) { [weak self] in
                self?.delegate?.didLoadData()
            }
        }
    }
    
    func getSectionArray(date: String) {
        if let ticketsArray = ticketsDict[date] {
            sectionSelected = ticketsArray
            return
        }
        return }
}
