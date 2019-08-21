//
//  NewsFeedViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/11/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

enum NewsFeedViewControllerState {
    case pulled, initialLoading, initialLoaded([NewsFeedItem], showFeatured: Bool), nextPageLoaded([NewsFeedItem]), error
}

class NewsFeedViewController: UIViewController {
    
    // MARK: - Variables
    
    private var feedItems: [NewsFeedItem] = [NewsFeedItem]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var featured: NewsFeedItem? {
        didSet {
            if let featured = featured {
                featuredView.model = FeaturedNewsModel.init(item: featured)
                showFeaturedHeader()
            } else {
                hideFeaturedHeader()
            }
        }
    }
    private var expanded = [IndexPath: CGFloat]()
    private var state: NewsFeedViewControllerState = .initialLoading {
        didSet {
            switch state {
            case .pulled:
                refreshControl.beginRefreshing()
                delayOnMainThread(1.0) {
                    self.loadFeed(initial: true)
                }
            case .initialLoading:
                activityIndicator.startAnimating()
                loadFeed(initial: true)
            case .initialLoaded(let items, let showFeatured):
                activityIndicator.stopAnimating()
                refreshControl.endRefreshing()
                if showFeatured, let featured = items.filter({ $0.isFeatured }).first {
                    self.featured = featured
                } else {
                    self.featured = nil
                }
                feedItems = items.filter({ !$0.isFeatured })
            case .nextPageLoaded(let items):
                collectionView.finishInfiniteScroll()
                guard items.count > 0 else { return }
                feedItems.append(contentsOf: items)
            case .error:
                activityIndicator.stopAnimating()
                collectionView.finishInfiniteScroll()
                refreshControl.endRefreshing()
                showMessage("Error Loading News Feed", title: "Error")
            }
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var featuredView: FeaturedNewsView!
    @IBOutlet weak var featuredViewTopConstraint: NSLayoutConstraint!
    lazy var refreshControl = UIRefreshControl()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "INHOUSE"
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        collectionView.backgroundView = refreshControl
        collectionView.addInfiniteScroll { (collectionView) -> Void in
            self.loadFeed(initial: false)
        }
        NotificationCenter.default.addObserver(forName: .scrollToTop, object: nil, queue: nil, using: catchNotification(notification:))
        state = .initialLoading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("NewsFeed")
    }
    
    // MARK: - Load Feed
    
    private func loadFeed(initial: Bool) {
        InHouseAPI.shared.getNewsFeed(initial: initial) { [unowned self] (success, items, showFeatured, error) in
            guard success, let items = items else {
                self.state = .error
                return
            }
            if initial {
                self.state = .initialLoaded(items, showFeatured: showFeatured)
            } else {
                self.state = .nextPageLoaded(items)
            }
        }
    }
    
    // MARK: - Pulled To Refresh
    
    @objc func pulledToRefresh() {
        state = .pulled
    }
    
    // MARK: - Present
    
    private func presentNewsFeedItem(_ item: NewsFeedItem) {
        if let string = item.urlString, let url = URL.init(string: string) {
            if url.absoluteString.contains("instagram.com") {
                UIApplication.shared.openURL(url)
            } else {
                presentWebsite(url, titleString: item.title)
            }
        } else {
            showMessage("Missing or Invalid Article Link", title: "Error")
        }
    }
    
    // MARK: - Notification
    
    private func catchNotification(notification: Notification) -> Void {
        collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    // MARK: - Animate Featured Header
    
    private func showFeaturedHeader() {
        animateFeaturedHeader(constant: 0)
    }
    
    private func hideFeaturedHeader() {
        animateFeaturedHeader(constant: -FeaturedNewsView.height)
    }
    
    private func animateFeaturedHeader(constant: CGFloat) {
        guard featuredViewTopConstraint.constant != constant else { return }
        featuredViewTopConstraint.constant = constant
        UIView.animate(withDuration: 0.6, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - IBAction
    
    @IBAction func tapFeatured(_ sender: UIButton) {
        MixpanelHelper.buttonTap("FeaturedNews")
        if let item = featured {
            presentNewsFeedItem(item)
        }
    }
    
    @IBAction func tapSettings(_ sender: UIBarButtonItem) {
        presentSettings()
    }
}

// MARK: - UICollectionViewDataSource

extension NewsFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsFeedCell.identifier(), for: indexPath) as! NewsFeedCell
        cell.newsDelegate = self
        cell.cellDelegate = self
        cell.model = NewsViewModel.init(feedItems[indexPath.row])
        cell.layoutIfNeeded()
        cell.expanded = expanded[indexPath] != nil
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension NewsFeedViewController:  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MixpanelHelper.buttonTap("NewsItem")
        presentNewsFeedItem(feedItems[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let height = expanded[indexPath] {
            return CGSize.init(width: UIScreen.main.bounds.width, height: height)
        } else {
            return NewsFeedCell.defaultSize()
        }
    }
}

// MARK: - NewsFeedCellDelegate

extension NewsFeedViewController: NewsFeedCellDelegate {
    func expandNews(_ cell: NewsFeedCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            if expanded[indexPath] != nil {
                expanded.removeValue(forKey: indexPath)
            } else {
                expanded[indexPath] = cell.intrinsicTotalHeight()
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: - NewsFeedItemDelegate

extension NewsFeedViewController: NewsFeedItemDelegate {
    func toggleNewsLike(_ cell: NewsFeedCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let item = feedItems[indexPath.row]
            let likes = item.likes ?? 0
            let isLiked = item.isLiked ?? false
            
            let new: Int
            if isLiked {
                new = likes - 1
            } else {
                new = likes + 1
            }
            
            item.isLiked = !isLiked
            item.likes = new
            cell.model = NewsViewModel.init(item)
            
            if let id = item.id {
                InHouseAPI.shared.toggleNewsFeedItemLike(id) { (success, item, error)  in
                    if !success {
                        Printer.print("error liking: \(error.debugDescription)")
                    }
                }
            }
        }
    }
    
    func shareNewsWithLink(_ url: URL, title: String) {
        let betOptionsAlert = UIAlertController.init(title: nil, message: "Share this post with a friend", preferredStyle: .actionSheet)
        let emailAction = UIAlertAction(title: "Share Via Email", style: .default) { (action) in
            self.sharePostViaEmail(url.absoluteString, title: title)
        }
        betOptionsAlert.addAction(emailAction)
        
        let textAction = UIAlertAction(title: "Share Via Text", style: .default) { (action) in
            self.sharePostViaText(url.absoluteString, title: title)
        }
        betOptionsAlert.addAction(textAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        betOptionsAlert.addAction(cancelAction)
        present(betOptionsAlert, animated: true, completion: nil)
    }
}
