//
//  SettingsMenuTableViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/13/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit

class SettingsMenuTableViewController: UITableViewController {
    
    // MARK: Variables
    
    private var versionLabel: UILabel!
    
    // MARK: Cells
    
    private enum Cells {
        case header, profile, about, questions, terms, privacy
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard versionLabel == nil else { return }
        
        let yOffset = 24.0 + bottomLayoutGuide.length
        versionLabel = UILabel.init(frame: CGRect.init(x: 0, y: view.bounds.height - yOffset, width: UIScreen.main.bounds.width, height: 40))
        versionLabel.textAlignment = .center
        versionLabel.textColor = Colors.OffWhite
        versionLabel.font = Fonts.Colfax.Medium(14)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "V\(version)"
        }
        tableView.addSubview(versionLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("SettingsMenu")
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: IBAction
    
    @IBAction func tapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let options = segue.destination as? SettingsInfoViewController else { return }
        
        if segue.identifier == "Terms", let path = Bundle.main.path(forResource: "terms", ofType: "html") {
                options.url = URL.init(fileURLWithPath: path)
        } else if segue.identifier == "Privacy", let path = Bundle.main.path(forResource: "privacy", ofType: "html") {
            options.url = URL.init(fileURLWithPath: path)
        }
    }
}

// MARK: TableViewDelegate

extension SettingsMenuTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == Cells.questions.hashValue {
            NotificationCenter.default.post(name: .switchToContact, object: nil)
            dismiss(animated: true, completion: nil)
        }
    }
}
