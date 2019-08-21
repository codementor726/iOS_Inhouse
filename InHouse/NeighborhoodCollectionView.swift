//
//  NeighborhoodCollectionView.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/8/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

protocol NeighborhoodCollectionViewDelegate: class {
    func neighborhoodIdsChanged(_ neighborhoodIds: [Int])
}

class NeighborhoodCollectionView: UICollectionView  {
    
    // MARK: Variables
    
    var neighborhoods: [Neighborhood] = [Neighborhood]() {
        didSet {
            reloadData()
        }
    }
    public var selectedIds: [Int] = [Int]() {
        didSet {
            neighborhoodDelegate?.neighborhoodIdsChanged(selectedIds)
            reloadData()
        }
    }
    weak var neighborhoodDelegate: NeighborhoodCollectionViewDelegate?
    
    // MARK: Awake
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
    }
}

// MARK: Delegate/DataSource

extension NeighborhoodCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return neighborhoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeighborhoodSelectCellIdentifier", for: indexPath) as! NeighborhoodSelectCell
        let neighborhood = neighborhoods[indexPath.row]
        cell.neighborhoodLabel.text = neighborhood.displayString()
        if let _ = selectedIds.index(where: { $0 == neighborhood.id }) {
            cell.configureSelected()
        } else {
            cell.configureUnselected()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = selectedIds.index(where: { $0 == neighborhoods[indexPath.row].id }) {
            selectedIds.remove(at: index)
        } else {
            selectedIds.append(neighborhoods[indexPath.row].id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let titleLabel = UILabel.init()
        let neighborhood = neighborhoods[indexPath.row]
        titleLabel.text = neighborhood.displayString()
        titleLabel.font = Fonts.Colfax.Medium(16)
        return CGSize.init(width: titleLabel.intrinsicContentSize.width + 16, height: NeighborhoodSelectCell.height())
    }
}

// MARK: Cell

class NeighborhoodSelectCell: UICollectionViewCell {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var neighborhoodLabel: UILabel!
    
    // MARK: Function
    
    func configureSelected() {
        neighborhoodLabel.textColor = .white
        backgroundColor = Colors.OffWhite.withAlphaComponent(0.3)
    }
    
    func configureUnselected() {
        neighborhoodLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        backgroundColor = Colors.OffWhite.withAlphaComponent(0.15)
    }
}

// MARK: Class Func

extension NeighborhoodSelectCell {
    class func identifier()-> String {
        return "NeighborhoodSelectCellIdentifier"
    }
    
    class func height()-> CGFloat {
        return 34
    }
}
