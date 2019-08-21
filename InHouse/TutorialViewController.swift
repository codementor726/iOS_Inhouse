//
//  TutorialViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/14/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import SMPageControl

class TutorialViewController: UIViewController {
    
    // MARK: Variables
    
    var currentIndex: Int = 0
    
    // MARK: IBOutlet
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var pageControl: SMPageControl!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var getStartedButton: UIButton!
    
    // MARK: UI Variables
    
    var subtitleStyle: NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = 20
        return paragraphStyle
    }
    
    // MARK: View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("Tutorial")
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    // MARK: Screens
    
    enum Screens {
        case one, two, three, four
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.indicatorMargin = 7
        pageControl.indicatorDiameter = 20
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorImage = Images.PageControl.Unselected
        pageControl.currentPageIndicatorImage = Images.PageControl.Selected
        
        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(self.swipeLeft(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(self.swipeRight(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        titleLabel.text = Copy.Tutorial.FirstTitle
        subtitleLabel.attributedText = NSAttributedString.init(string: Copy.Tutorial.FirstSubtitle, attributes: [NSAttributedStringKey.font : Fonts.Colfax.Regular(14), NSAttributedStringKey.paragraphStyle : subtitleStyle])
        imageView.image = Images.Tutorial.One
    }
    
    // MARK: Switching
    
    func animateForPosition(_ int: Int) {
        pageControl.currentPage = int
        getStartedButton.isHidden = !(int == Screens.four.hashValue)
        pageControl.isHidden = !getStartedButton.isHidden
        switch int {
        case 0:
            titleLabel.text = Copy.Tutorial.FirstTitle
            subtitleLabel.attributedText = NSAttributedString.init(string: Copy.Tutorial.FirstSubtitle, attributes: [NSAttributedStringKey.font : Fonts.Colfax.Regular(14), NSAttributedStringKey.paragraphStyle : subtitleStyle])
            imageView.image = Images.Tutorial.One
        case 1:
            titleLabel.text = Copy.Tutorial.SecondTitle
            subtitleLabel.attributedText = NSAttributedString.init(string: Copy.Tutorial.SecondSubtitle, attributes: [NSAttributedStringKey.font : Fonts.Colfax.Regular(14), NSAttributedStringKey.paragraphStyle : subtitleStyle])
            imageView.image = Images.Tutorial.Two
        case 2:
            titleLabel.text = Copy.Tutorial.ThirdTitle
            subtitleLabel.attributedText = NSAttributedString.init(string: Copy.Tutorial.ThirdSubtitle, attributes: [NSAttributedStringKey.font : Fonts.Colfax.Regular(14), NSAttributedStringKey.paragraphStyle : subtitleStyle])
            imageView.image = Images.Tutorial.Three
        case 3:
            titleLabel.text = Copy.Tutorial.FourthTitle
            subtitleLabel.attributedText = NSAttributedString.init(string: Copy.Tutorial.FourthSubtitle, attributes: [NSAttributedStringKey.font : Fonts.Colfax.Regular(14), NSAttributedStringKey.paragraphStyle : subtitleStyle])
            imageView.image = Images.Tutorial.Four
        default:
            assertionFailure()
        }
    }
    
    // MARK: IBAction
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if currentIndex != 0 {
            currentIndex = currentIndex - 1
            animateForPosition(currentIndex)
        }
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if currentIndex != 3 {
            currentIndex = currentIndex + 1
            animateForPosition(currentIndex)
        }
    }
    
    @IBAction func tapGetStarted(_ sender: UIButton) {
        MixpanelHelper.buttonTap("TutorialGetStarted")
        transitionToGrantLocation()
    }
}
