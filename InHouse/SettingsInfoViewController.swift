//
//  SettingsInfoViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/13/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class SettingsInfoViewController: UIViewController {
    
    // MARK: Public Variables
    
    public var url: URL?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        loadPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MixpanelHelper.screenView("LegalScreen")
        webView.stopLoading()
    }
    
    // MARK: Load Page
    
    func loadPage() {
        if let url = url {
            let request = URLRequest.init(url: url)
            webView.loadRequest(request)
        }
    }
}

extension SettingsInfoViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
}
