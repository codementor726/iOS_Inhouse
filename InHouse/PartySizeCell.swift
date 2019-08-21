//
//  PartySizeCell.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/13/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

// MARK: Model

struct PartySizeCellViewModel {
    var title: String
    var titleColor: UIColor
    var backgroundColor: UIColor?
    
    init(title: String, titleColor: UIColor, backgroundColor: UIColor?) {
        self.title = title
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
    }
}

// MARK: Cell

class PartySizeCell: UICollectionViewCell {
    
    // MARK: Variables
    
    var viewModel: PartySizeCellViewModel? {
        didSet {
            if let vm = viewModel {
                configureView(vm)
            }
        }
    }
    
    // MARK: IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Configure
    
    private func configureView(_ viewModel: PartySizeCellViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.titleColor
        if viewModel.backgroundColor != nil {
            titleLabel.backgroundColor = viewModel.backgroundColor
        }
    }
    
    // MARK: Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.backgroundColor = Colors.DarkBlue
    }
}

// MARK: Class Func

extension PartySizeCell {
    class func identifier() -> String {
        return "PartySizeCellIdentifier"
    }
}
