//
//  NewsFeedCell.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/11/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import SDWebImage

protocol NewsFeedCellDelegate: class {
    func expandNews(_ cell: NewsFeedCell)
}

protocol NewsFeedItemDelegate: class {
    func toggleNewsLike(_ cell: NewsFeedCell)
    func shareNewsWithLink(_ url: URL, title: String)
}

class NewsFeedCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    public var model: NewsViewModel? {
        didSet {
            if let model = model {
                configure(model)
            }
        }
    }
    public var expanded: Bool = false {
        didSet {
            if expanded {
                moreButton.isHidden = false
                moreButton.setTitle("less", for: .normal)
            } else {
                moreButton.isHidden = !subtitleLabel.isTruncated(14)
                moreButton.setTitle("more", for: .normal)
            }
            
        }
    }
    weak var newsDelegate: NewsFeedItemDelegate?
    weak var cellDelegate: NewsFeedCellDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    // MARK: Configure
    
    public func configure(_ model: NewsViewModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.description
        dateLabel.text = model.date?.stringWithFormat("MMM d, YYYY")
        likeLabel.text = "\(model.likes ?? 0)"
        if let path = model.imagePath {
            imageView.sd_setImage(with: URL.init(string: path))
        }
        shareButton.isEnabled = (model.urlString != nil)
        if model.isLiked == true {
            likeButton.setImage(Images.NewsFeed.LikedIcon, for: .normal)
        } else {
            likeButton.setImage(Images.NewsFeed.NotLikedIcon, for: .normal)
        }
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if imageView.image != nil {
            imageView.image = nil
        }
        moreButton.isHidden = false
    }
    
    // MARK: - Helper
    
    func intrinsicTotalHeight()-> CGFloat {
        return subtitleLabel.intrinsicContentSize.height + (NewsFeedCell.defaultHeight() - subtitleLabel.frame.size.height)
    }
    
    // MARK: - IBAction
    
    @IBAction func tapLike(sender: UIButton) {
        if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator().impactOccurred()
        }
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .allowUserInteraction, animations: {
            self.likeButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { finished in
            UIView.animate(withDuration: 0.2, animations: {
                self.likeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
        MixpanelHelper.buttonTap("LikeNews")
        newsDelegate?.toggleNewsLike(self)
    }
    
    @IBAction func tapShare(sender: UIButton) {
        MixpanelHelper.buttonTap("ShareNews")
        if let model = model, let urlString = model.urlString, let url = URL.init(string: urlString), let title = model.title {
            newsDelegate?.shareNewsWithLink(url, title: title)
        } 
    }
    
    @IBAction func tapMore(sender: UIButton) {
        MixpanelHelper.buttonTap("ExpandNews")
        cellDelegate?.expandNews(self)
    }
}

// MARK: - Identifiers/Sizing

extension NewsFeedCell {
    class func identifier()-> String {
        return "NewsFeedCellIdentifier"
    }
    
    class func defaultSize()-> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: defaultHeight())
    }
    
    class func defaultHeight()-> CGFloat {
        return 308.0
    }
}
