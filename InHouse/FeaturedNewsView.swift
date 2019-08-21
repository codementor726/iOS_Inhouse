//
//  FeaturedNewsView.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/19/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class FeaturedNewsView: UIView {
    
    // MARK: - Variables
    
    var model: FeaturedNewsModel? {
        didSet {
            if let model = model {
                configure(model)
            }
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    
    // MARK: - Configure
    
    public func configure(_ model: FeaturedNewsModel) {
        headlineLabel.text = model.headline
        if let path = model.imagePath {
            imageView.sd_setImage(with: URL.init(string: path))
        }
    }
}

// MARK: Class Func

extension FeaturedNewsView {
    class func identifier()-> String {
        return "FeaturedNewsViewIdentifier"
    }
    
    class var height: CGFloat {
        return 129.0
    }
}
