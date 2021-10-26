//
//  CalendarSelection.swift
//  JTCalendarCustom
//
//  Created by Lam Le Tung on 12/14/18.
//  Copyright © 2018 ltlam. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarSelectionController: BaseController {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet weak var selectedDates: UILabel!
    @IBOutlet weak var btnApplyDateSelection: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mon: UILabel!
    @IBOutlet weak var tue: UILabel!
    @IBOutlet weak var wed: UILabel!
    @IBOutlet weak var thu: UILabel!
    @IBOutlet weak var fri: UILabel!
    @IBOutlet weak var sat: UILabel!
    @IBOutlet weak var sun: UILabel!
    
    let formatter = DateFormatter()
    var datesToDeselect: [Date]?
    var dateSelect = Date()
    var datesSelect: [Date]?
    //    var delegate:CalendarDelegate?
    var startDate = Date()
    var endDate = Date()
    var isSelected = true
    var isClear = true
    var isClearDates = false
    var datesRange = -1
    let df = DateFormatter()
    @IBOutlet weak var calendarWidth: NSLayoutConstraint!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: CalendarSelectionViewModel?
    var dataSource: CalendarSelectionDataSource?
    
    let backgroudViewColor = UIColor.init(red: 230/255, green: 0, blue: 0, alpha: 0.5)
    
    @IBAction func onBack(_ sender: Any) {
        //        Utility.backToPreviousScreen(self)
    }
    
    @IBAction func next(_ sender: Any) {
        self.calendarView.scrollToSegment(.next)
    }
    
    @IBAction func previous(_ sender: Any) {
        self.calendarView.scrollToSegment(.previous)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel!.loadData()
        loadNavbar()
        loadCalendarView()
        loadCollectionView()
    }
    
    func loadNavbar() {
        let itemNew = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(setBack))
        navigationItem.leftBarButtonItem = itemNew
        let textChangeColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textChangeColor
        navigationItem.title = "Please select a date"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func loadCalendarView() {
        let date = Date()
        calendarHeight.constant = 340.0
        self.calendarView.scrollToDate(date, animateScroll: false)
        calendarView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
        }
        calendarView.isRangeSelectionUsed = false
        calendarView.allowsMultipleSelection = false
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    func loadCollectionView() {
        dataSource = CalendarSelectionDataSource(viewModel: viewModel!, delegate: self)
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.registerNib(cellClass: SectionDurationCell.self)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
    @objc func setBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func initData(_ dates: [Date]) {
        calendarView.selectDates(
            from: dates.first!,
            to: dates.last!,
            triggerSelectionDelegate: true,
            keepSelectionIfMultiSelectionAllowed: true)
        
        calendarView.reloadData()
    }
    
    func initDate(){
        if let firstDate = calendarView.selectedDates.first, let lastDate = calendarView.selectedDates.last {
            selectedDates.text = convertDateFormat(firstDate) + " to " + convertDateFormat(lastDate)
            startDate = firstDate
            endDate = lastDate
        }
    }
    
    func setupMonthLabel(date: Date) {
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        let year = String(anchorComponents.year ?? 2018)
        if let month = anchorComponents.month{
            monthLabel.text = DateFormatter().monthSymbols[month - 1]
        } else {
            monthLabel.text = DateFormatter().monthSymbols[0]
        }
        
        yearLabel.text = year
        
        // day of week
        mon.text = "MON"
        tue.text = "TUE"
        wed.text = "WED"
        thu.text = "THU"
        fri.text = "FRI"
        sat.text = "SAT"
        sun.text = "SUN"
    }
    
    func handleConfiguration(cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? TestRangeSelectionViewControllerCell else { return }
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func handleCellColor(cell: TestRangeSelectionViewControllerCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            let formattedDateString = RMBDateFormat.mdySimple.formatted(date: cellState.date)
            if (viewModel?.datesSelectString.contains(formattedDateString))!{
                cell.label.textColor = .white} else {
                cell.label.textColor = .darkGray
            }
        } else {
            cell.label.textColor = .darkGray
        }
    }
    
    func handleCellSelection(cell: TestRangeSelectionViewControllerCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.selectedView.isHidden = !cellState.isSelected
            switch cellState.selectedPosition() {
            case .full, .left, .right, .middle:
                cell.circleView.isHidden = false
                cell.circleView.layer.cornerRadius = cell.circleView.frame.size.width/2
                
                cell.selectedView.backgroundColor = backgroudViewColor
                cell.selectedView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: cell.selectedView.frame.size.width/2)
                cell.selectedView.isHidden = true
                // Define and create attributes/shadow for calendar
                cell.label.textColor = .black
                let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 18)
                let attributes :Dictionary = [NSAttributedString.Key.font : labelFont]
                let attrString = NSAttributedString(string: cell.label.text ?? "", attributes:attributes as [NSAttributedString.Key : Any])
                cell.label.attributedText = attrString
                cell.circleView.dropShadow(color: .white, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 2, scale: true, cornerRadius: cell.circleView.frame.height/2)
            default:
                cell.circleView.isHidden = true
                break
            }
        } else {
            cell.selectedView.isHidden = true
            cell.circleView.isHidden = true
        }
    }
}

extension CalendarSelectionController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! TestRangeSelectionViewControllerCell
        cell.label.text = cellState.text
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        if cellState.dateBelongsTo == .thisMonth {
            let formattedDateString = RMBDateFormat.mdySimple.formatted(date: date)
            if (viewModel?.datesSelectString.contains(formattedDateString))!{
                cell.isUserInteractionEnabled = true}
            else {
                cell.isUserInteractionEnabled = false
            }
        } else {
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleConfiguration(cell: cell, cellState: cellState)
        activeButton()
        isSelected = false
        //        if (calendar.selectedDates.count > 1) {
        if (isClearDates) {
            self.isClearDates = false
            //calendar.deselectAllDates()
            calendar.selectDates(from: date, to: date)
            calendar.reloadData()
        }
        self.selectedDates.text = RMBDateFormat.monthDayYear.formatted(date: calendar.selectedDates.first!)
        viewModel?.getSectionArray(date: RMBDateFormat.mdySimple.formatted(date: calendar.selectedDates.first!))
        isClear = true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
        if isSelected {activeButton()}
        if (calendar.selectedDates.count == 1) {
            self.selectedDates.text = RMBDateFormat.monthDayYear.formatted(date: calendar.selectedDates.first!)
        } else{
            self.initDate()
        }
        isSelected = true
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        
        let startDate = df.date(from: "01-01-2020")!
        let endDate = df.date(from: "12-31-2030")!
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .monday)
        return parameter
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        dateSelect = date
        datesToDeselect?.append(date)
        
        if (calendar.selectedDates.count == 0) {
            selectedDates.text = RMBDateFormat.monthDayYear.formatted(date: date)
            startDate = date
            endDate = date
        }
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        
        let selectedDates = calendar.selectedDates
        dateSelect = date
        isSelected = true
        self.isClearDates = false
        if selectedDates.contains(date) {
            if (selectedDates.count > 1 && isClear) {
                self.isClear = false
                calendar.deselectAllDates()
                calendar.selectDates(from: date, to: date)
                calendarView.reloadData(withanchor: date, completionHandler: {
                })
            }
        }
        return true
    }
}

class TestRangeSelectionViewControllerCell: JTAppleCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var circleView: UIView!
}

extension CalendarSelectionController {
    @IBAction func applyDateSelection(_ sender: Any) {
        if User.current() == nil {
            blockGuest()
            return
        }
        let indexPath = collectionView.indexPathsForSelectedItems?.first
        let sectionTicket = (viewModel?.sectionSelected[indexPath!.row])!
        let paymentViewModel = PaymentViewModel(event: sectionTicket.event!, tickets: [viewModel!.sectionSelected[indexPath!.row]])
        let payment = PaymentController(viewModel: paymentViewModel)
        navigationController?.pushViewController(payment, animated: true)
    }
    
}
extension CalendarSelectionController {
    func convertDateFormat(_ date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // month
        let month = String(anchorComponents.month ?? 1)
        
        // day of month
        let day = String(anchorComponents.day ?? 1)
        
        // year
        let year = String(anchorComponents.year ?? 2018)
        
        let result = String(format: "%1$@-%2$@-%3$@", day, month, year)
        return result
    }
}

extension CalendarSelectionController: CalendarSelectionViewModelDelegate {
    func didLoadData() {
        btnApplyDateSelection.isHidden = true
        calendarView.reloadData()
        collectionView.reloadData()
    }
    
    func didFail(error: String, removeFromTop: Bool) {
        //        stopLoading { [weak self] in
        //            self?.showError(err: error)
        //        }
        //        if removeFromTop {
        //            navigationController?.popViewController(animated: true)
        //        }
    }
    
    func didSuccess(msg: String, removeFromTop: Bool) {
        //        stopLoading { [weak self] in
        //            self?.showSuccess(success: msg)
        //        }
        //        if removeFromTop {
        //            navigationController?.popViewController(animated: true)
        //        }
    }
}

extension CalendarSelectionController: CalendarSelectionDataSourceDelegate {
    func activeButton() {
        if calendarView.selectedDates.count == 0 || collectionView.indexPathsForSelectedItems?.count == 0 {
            btnApplyDateSelection.isHidden = true
            btnApplyDateSelection.backgroundColor = UIColor(red:13/255, green:13/255, blue:13/255, alpha:1)
            btnApplyDateSelection.setTitleColor(UIColor.AppColors.darkGray, for: .normal)
        } else {
            btnApplyDateSelection.isHidden = false
            btnApplyDateSelection.backgroundColor = UIColor(red:13/255, green:13/255, blue:13/255, alpha:1)
            btnApplyDateSelection.setTitleColor(UIColor.white, for: .normal)
            selectedDates.isHidden = false
        }
        
    }
}

// MARK: - Instance View Controller
extension CalendarSelectionController {
    static var instance: CalendarSelectionController {
        guard let vc = UIStoryboard(name: "HomePage", bundle: nil).instantiateViewController(withIdentifier: "CalendarSelectionController") as? CalendarSelectionController else {
            assertionFailure("Something wrong while instantiating ProfileController")
            return CalendarSelectionController()
        }
        return vc
    }
}

