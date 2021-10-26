//
//  RatingViewController.swift
//  ramble-ios
//
//  Created by Hexiao Zhang on 2020-05-05.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit

class RatingViewController: BaseController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var buttonDone: RMBButton!
    @IBOutlet weak var eventView: EventView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var laterButton: UIButton!
    
    var viewModel = RatingViewModel()
    var starSubView: StarRateView!
    var eventId: String?
    
    public init(event: Event) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.type = .setup
        self.viewModel.event = event
        
    }
    
    public init(Id: String) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.type = .setup
        self.viewModel.setEvent(Id: Id)
    }
    
    public init(event: Event, review: Review) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.type = .edit
        self.viewModel.event = event
        self.viewModel.review = review
        self.viewModel.star = review.star
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setUpStatView()
        setUpEventView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func submitReview(_ sender: Any) {
        viewModel.saveReview()
    }
    
    @IBAction func refuseToRate(_ sender: Any) {
        replaceRootViewController(to: TabbarController.instance, animated: true, completion: nil)
    }
    
    
    func setUpStatView(){
        switch viewModel.type{
        case .setup:
              starSubView = StarRateView(frame: CGRect(x: 0, y: 0, width: 240, height: 40),totalStarCount: 5, starSpace: 10)
        default:
            starSubView = StarRateView(frame: CGRect(x: 0, y: 0, width: 240, height: 40),totalStarCount: 5, starSpace: 10, currentStarCount: CGFloat(self.viewModel.star))
        }

        self.starView.addSubview(starSubView)
        starSubView.center = CGPoint(x: self.starView.frame.size.width/2,
                                     y: self.starView.frame.size.height/2)
        starSubView.show { (score) in
            self.viewModel.star = Int(score)
            DispatchQueue.main.async{
                self.getComment(startNumber: Int(score))
            }
        }
    }
    
    func setupUI(){
        switch viewModel.type{
        case .setup:
            titleLabel.text = "How was this experience?"
            self.buttonDone.applyGradient(colours: [UIColor.AppColors.buttonLeft, UIColor.AppColors.buttonRight])
            self.buttonDone.clipsToBounds = true
            self.commentLabel.text = "Rate your experience!"
            self.laterButton.setTitle("Later", for: .normal)
        case .edit:
            titleLabel.text = "You have rated this experience!"
            self.buttonDone.isHidden = true
            self.getComment(startNumber: viewModel.star)
            self.laterButton.setTitle("Back", for: .normal)
        }
        titleLabel.addCharacterSpacing(kernValue: -2.0)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func getComment(startNumber: Int){
        switch startNumber {
        case 5: self.commentLabel.text = "Awesome"
        case 4: self.commentLabel.text = "Very good"
        case 3: self.commentLabel.text = "Not bad"
        case 2: self.commentLabel.text = "Acceptable"
        case 1: self.commentLabel.text = "Never again"
        default:
            self.commentLabel.text = "Rate your experience!"
        }
    }
}
extension RatingViewController: RatingViewModellDelegate{
    
    func setUpEventView(){
        eventView.configure(with: EventViewModel(event: viewModel.event))
        self.eventView.backgroundColor = UIColor.AppColors.background
    }
    
    func didSuccess(msg: String) {
        stopLoading { [weak self] in
            self?.showSuccess(success: msg)
//            replaceRootViewController(to: TabbarController.instance, animated: true, completion: nil)
        }
//        navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            replaceRootViewController(to: TabbarController.instance, animated: true, completion: nil)
        })
    }
    
    func didFail(error: String) {
        stopLoading { [weak self] in
            self?.showError(err: error)
        }
        navigationController?.popViewController(animated: true)
    }
}
