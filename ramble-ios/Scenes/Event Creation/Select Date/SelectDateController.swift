//
//  SelectDateController.swift
//  ramble-ios
//
//  Created by Ramble Technologies on 2018-08-02.
//  Copyright © 2018 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import UIKit

protocol SelectDateControllerDelegate: class {
    func didSelect(date: Date, type: DateType)
}

class SelectDateController: BaseController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarDayView: JTHorizontalCalendarView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let calendarManager = JTCalendarManager()
    
    var viewModel = SelectDateViewModel()
    weak var delegate: SelectDateControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNavbar()
        loadLayout()
        initData()
    }
    
    // MARK: Navigation
    private func loadNavbar() {
        navigationController?.setBack()
        navigationItem.title = viewModel.navTitle
        
        let itemDone = UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(actionDone))
        navigationItem.rightBarButtonItem = itemDone
    }
    
    // MARK: Layout
    
    private func loadLayout() {
        calendarMenuView.roundCorner(with: 16, to: [.topLeft, .topRight])
        calendarDayView.roundCorner(with: 16, to: [.bottomLeft, .bottomRight])
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        datePicker.roundCorner(with: 16)
        datePicker.datePickerMode = .time
    }
    
    private func initData() {
        datePicker.setDate(viewModel.selectedDate, animated: true)
        calendarManager.setDate(viewModel.selectedDate)
        dateLabel.text = viewModel.formattedDate()
    }
    
    func setupCalendarView() {
        calendarManager.delegate = self
        calendarManager.menuView = calendarMenuView
        calendarManager.contentView = calendarDayView
        calendarManager.setDate(viewModel.selectedDate)
    }
    
    // MARK: - Actions
    @objc private func actionDone() {
        delegate?.didSelect(date: viewModel.selectedDate, type: viewModel.dateType)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionDatePickerChanged(_ sender: UIDatePicker) {
        viewModel.selectTime(date: sender.date)
    }
}

// MARK: - SelectDateViewModelDelegate
extension SelectDateController: SelectDateViewModelDelegate {
    func didChangeDate() {
        dateLabel.text = viewModel.formattedDate()
        calendarManager.setDate(viewModel.selectedDate)
        datePicker.setDate(viewModel.selectedDate, animated: true)
        calendarManager.reload()
    }
    
    func didSelectPastDate() {
        showError(err: RMBError.selectDateCantSelectPastDate.localizedDescription)
        datePicker.setDate(Date(), animated: true)
    }
}

// MARK: - JTCalendarDelegate
extension SelectDateController: JTCalendarDelegate {
    
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: (UIView & JTCalendarDay)!) {
        guard let calendarDayView = dayView as? JTCalendarDayView else { return }
        
        loadLayout(for: calendarDayView)
        
        if !viewModel.isSelectableDate(date: calendarDayView.date) {
            calendarDayView.textLabel.textColor = UIColor.AppColors.gray
            calendarDayView.textLabel.font = Fonts.Helvetica.light.size(16)
        
        } else if calendarDayView.date.equals(viewModel.selectedDate) {
            loadLayout(forSelected: calendarDayView)
        }
      
    }
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: (UIView & JTCalendarDay)!) {
        guard let calendarDayView = dayView as? JTCalendarDayView else { return }
        
        if viewModel.isSelectableDate(date: calendarDayView.date) {
            viewModel.selectDay(date: calendarDayView.date)
            calendarDayView.manager.reload()
            
        }
    }
    
    func calendarBuildMenuItemView(_ calendar: JTCalendarManager!) -> UIView! {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        button.titleLabel?.font = Fonts.Futura.medium.size(16)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.AppColors.unselectedTextGray, for: .normal)
        button.tintColor = UIColor.AppColors.unselectedTextGray
        button.isUserInteractionEnabled = false
        
        return button
    }
    
    func calendar(_ calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: Date!) {
        guard let menuItemButton = menuItemView as? UIButton else {
            return
        }
        menuItemButton.setTitle(RMBDateFormat.monthYear.formatted(date: calendarManager.date()), for: .normal)

    }
    
    // My custom methods for JTCalendar
    private func loadLayout(for calendarDayView: JTCalendarDayView) {
        
        calendarDayView.isHidden = false
        calendarDayView.circleView.isHidden = true
        calendarDayView.manager.settings.weekDayFormat = .single

        if calendarDayView.isFromAnotherMonth {
            calendarDayView.textLabel.textColor = UIColor.AppColors.gray
            calendarDayView.textLabel.font = Fonts.Helvetica.light.size(16)
        } else {
            calendarDayView.textLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            calendarDayView.textLabel.textColor = .white
        }
    }
    
    func loadLayout(forSelected calendarDayView: JTCalendarDayView) {
        calendarDayView.circleView.backgroundColor = UIColor.AppColors.gray
        calendarDayView.circleView.isHidden = false
        calendarDayView.circleView.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        calendarDayView.textLabel.textColor = UIColor.white
    }
}

extension SelectDateController {
    static var instance: SelectDateController {
        guard let vc = Storyboard.EventCreation.viewController(for: .selectDate) as? SelectDateController else {
            assertionFailure("Something wrong while instantiating SelectDateController")
            return SelectDateController()
        }
        return vc
    }
}
