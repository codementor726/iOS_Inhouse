//
//  PartyCollectionView.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/13/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

private let sizes: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

protocol PartyCollectionViewDelegate: class {
    func partySizeChanged(_ size: String)
}

class PartyCollectionView: UICollectionView  {
    
    weak var partySizeDelegate: PartyCollectionViewDelegate?
    fileprivate var selected: String = sizes[1] {
        didSet {
            partySizeDelegate?.partySizeChanged(selected)
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
    }
}

// MARK: UICollectionViewDataSource/Delegate

extension PartyCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartySizeCell.identifier(), for: indexPath) as! PartySizeCell
        
        if sizes[indexPath.row] == selected {
            cell.viewModel = PartySizeCellViewModel.init(title: sizes[indexPath.row], titleColor: .white, backgroundColor: Colors.OffRed)
        } else {
            cell.viewModel = PartySizeCellViewModel.init(title: sizes[indexPath.row], titleColor: Colors.DarkBlue, backgroundColor: Colors.GrayBlue)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = sizes[indexPath.row]
    }
}
