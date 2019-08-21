//
//  TwoSidedTimeSlider.swift
//  
//
//  Created by Kevin Johnson on 7/24/17.
//
//

import UIKit
import Timepiece

protocol TwoSidedTimeSliderDelegate: class {
    func preferredTimeChanged(_ date: Date)
    func minimumTimeChanged(_ date: Date)
    func maximumTimeChanged(_ date: Date)
}

class TwoSidedTimeSlider: UIView {
    
    // MARK: Variables
    
    var preferredTime: Date? {
        didSet {
            guard let preferred = preferredTime else { return }
            delegate?.preferredTimeChanged(preferred)
            minimumTime = preferred - 90.minutes
            maximumTime = preferred + 90.minutes
        }
    }
    var minimumTime: Date? {
        didSet {
            guard let min = minimumTime else { return }
            delegate?.minimumTimeChanged(min)
            
        }
    }
    var maximumTime: Date? {
        didSet {
            guard let max = maximumTime else { return }
            delegate?.maximumTimeChanged(max)
        }
    }
    weak var delegate: TwoSidedTimeSliderDelegate?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var minimumTimeSlider: UISlider!
    @IBOutlet weak var maximumTimeSlider: UISlider!
    
    // MARK: Setup
    
    override func awakeFromNib() {
        minimumTimeSlider.setThumbImage(Images.Misc.SliderIcon, for: .normal)
        maximumTimeSlider.setThumbImage(Images.Misc.SliderIcon, for: .normal)
        minimumTimeSlider.addTarget(self, action: #selector(self.minimumSliderChanged), for: .valueChanged)
        maximumTimeSlider.addTarget(self, action: #selector(self.maximumSliderChanged), for: .valueChanged)
    }
    
    // MARK: Sliding
    
    @objc func minimumSliderChanged(_ value: Float) {
        guard let preferred = preferredTime else { return }
        
        let value = minimumTimeSlider.value
        if value == 0.00 {
            minimumTime = preferred - 90.minutes
        } else if value < 0.20 && value > 0.00 {
            minimumTime = preferred - 75.minutes
        } else if value < 0.40 && value >= 0.20 {
            minimumTime = preferred - 60.minutes
        } else if value < 0.60 && value >= 0.40 {
            minimumTime = preferred - 45.minutes
        } else if value < 0.80 && value >= 0.60 {
            minimumTime = preferred - 30.minutes
        } else if value < 1.00 && value >= 0.80 {
            minimumTime = preferred - 15.minutes
        }
    }
    
    @objc func maximumSliderChanged(_ value: Float) {
        guard let preferred = preferredTime else { return }
        
        let value = maximumTimeSlider.value
        if value < 0.20 && value >= 0.00 {
            maximumTime = preferred + 15.minutes
        } else if value < 0.40 && value >= 0.20 {
            maximumTime = preferred + 30.minutes
        } else if value < 0.60 && value >= 0.40 {
            maximumTime = preferred + 45.minutes
        } else if value < 0.80 && value >= 0.60 {
            maximumTime = preferred + 60.minutes
        } else if value < 1.00 && value >= 0.80 {
            maximumTime = preferred + 75.minutes
        } else if value == 1.00 {
            maximumTime = preferred + 90.minutes
        }
    }
}
