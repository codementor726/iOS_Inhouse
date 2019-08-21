//
//  NewsWebViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/4/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class NewsWebViewController: UIViewController {

    // MARK: Variables
    
    var url: URL?
    var titleString: String?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = titleString
        if let url = url {
            let request = URLRequest.init(url: url)
            webView.loadRequest(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("NewsWebView")
    }

    // MARK: IBAction

    @IBAction func tapCancel(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: UIWebViewDelegate

extension NewsWebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.stopAnimating()
    }
}
