//
//  ViewControllerExtensions.swift
//  InHouse
//
//  Created by Kevin Johnson on 8/30/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import MessageUI
import ThirdPartyMailer

// MARK: Presentation

extension UIViewController {
    func presentSettings() {
        let settings = UIStoryboard.init(name: "Settings", bundle: nil).instantiateInitialViewController()!
        present(settings, animated: true, completion: nil)
    }
    
    func presentGrantCalendar(_ delegate: GrantCalendarViewControllerDelegate) {
        let calendar = UIStoryboard.init(name: "Grants", bundle: nil).instantiateViewController(withIdentifier: GrantCalendarViewController.identifier()) as! GrantCalendarViewController
        calendar.delegate = delegate
        present(calendar, animated: true, completion: nil)
    }
    
    func openInstagramImage(_ id: Int) {
        guard let nativeUrl = URL.init(string: "instagram://user?picture=\(id)"), let webUrl = URL.init(string: "http://wwww.instagram.com/\(id)") else { return }
        
        if UIApplication.shared.canOpenURL(nativeUrl) {
            UIApplication.shared.openURL(nativeUrl)
        } else if UIApplication.shared.canOpenURL(webUrl) {
            UIApplication.shared.openURL(webUrl)
        }
    }
    
    func presentWebsite(_ url: URL?, titleString: String?) {
        let newsWebNavVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsWebViewControllerNavIdentifier") as! UINavigationController
        let newsWebVC = newsWebNavVC.rootViewController as! NewsWebViewController
        newsWebVC.url = url
        newsWebVC.titleString = titleString
        present(newsWebNavVC, animated: true, completion: nil)
    }
}

// MARK: Maps

extension UIViewController {
    func openInGoogleMaps(coord: (lat: Double, long: Double), q: String) {
        if let mapString = "comgooglemaps://?center=\(coord.lat),\(coord.long)&zoom=15&views=traffic&q=\(q)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let mapURL = URL.init(string: mapString) {
            UIApplication.shared.openURL(mapURL)
        }
    }
    
    func openInAppleMaps(coord: (lat: Double, long: Double), q: String) {
        if let mapString = "http://maps.apple.com/?q=\(q)&sll=\(coord.lat),\(coord.long)&z=15&t=r".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let mapURL = URL.init(string: mapString) {
            UIApplication.shared.openURL(mapURL)
        }
    }
}

// MARK: Email/Text

extension UIViewController {
    func showMessage(_ message: String?, title: String?) {
        guard presentedViewController == nil else {
            Printer.print("Already Presenting View Controller")
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func tryThirdPartyMailers(subject: String?, body: String?, recipient: String?) {
        let clients = ThirdPartyMailClient.clients()
        let application = UIApplication.shared
        
        for client in clients {
            if ThirdPartyMailer.application(application, isMailClientAvailable: client) {
                _ = ThirdPartyMailer.application(application, openMailClient: client, recipient: recipient, subject: subject, body: body)
                return
            }
        }
        showMessage("Connect iOS Mail Client", title: "Error")
    }
    
    private func sendEmail(subject: String?, body: String?, recipient: String?) {
        if MFMailComposeViewController.canSendMail() {
            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = controller
            if let subject = subject {
                controller.setSubject(subject)
            }
            if let recipient = recipient {
                controller.setToRecipients([recipient])
            }
            if let body = body {
                controller.setMessageBody(body, isHTML: true)
            }
            present(controller, animated: true, completion: nil)
        } else {
            tryThirdPartyMailers(subject: subject, body: body, recipient: recipient)
        }
    }
    
    func emailMembershipInHouse(subject: String?, body: String?) {
        sendEmail(subject: subject, body: body, recipient: "membership@inhousenewyork.com")
    }
    
    func emailHelloInHouse(subject: String?, body: String?) {
        sendEmail(subject: subject, body: body, recipient: "hello@inhousenewyork.com")
    }
    
    func needHelpEmail() {
        sendEmail(subject: "Hi INHOUSE team - can you help?", body: "Hi - wondering if you might be able to help with…", recipient: "hello@inhousenewyork.com")
    }
    
    func sharePostViaEmail(_ urlString: String, title: String) {
        if MFMailComposeViewController.canSendMail() {
            let htmlBody = "Hi - here's a story that I thought you might find interesting: \(title) - <a>\(urlString)</a> <br></br><br><br></br><br></br><br></br>News from <a href='https://www.inhousenewyork.com'>INHOUSE</a>"
            sendEmail(subject: title, body: htmlBody, recipient: nil)
        } else {
        let plainBody = "Hi - here's a story that I thought you might find interesting: \(title) - \(urlString) - News from https://www.inhousenewyork.com"
            tryThirdPartyMailers(subject: title, body: plainBody, recipient: nil)
        }
    }
    
    func textInHouse(_ message: String?) {
        if MailComposeVC.canSendText() {
            UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: Colors.DarkBlue), for: .default)
            let controller = MailComposeVC()
            controller.messageComposeDelegate = controller
            controller.recipients = ["9177460340"]
            controller.body = message
            present(controller, animated: true, completion: {
                UIApplication.shared.statusBarStyle = .lightContent
            })
        } else {
            showMessage("Connect Messaging Client", title: "Error")
        }
    }
    
    func sharePostViaText(_ urlString: String, title: String) {
        if MailComposeVC.canSendText() {
            UINavigationBar.appearance().setBackgroundImage(UIImage.from(color: Colors.DarkBlue), for: .default)
            
            let controller = MailComposeVC()
            controller.messageComposeDelegate = controller
            controller.body = "\(title) - \(urlString)"
            
            present(controller, animated: true, completion: {
                UIApplication.shared.statusBarStyle = .lightContent
            })
        } else {
            showMessage("Connect Messaging Client", title: "Error")
        }
    }
}

extension MFMailComposeViewController: MFMailComposeViewControllerDelegate {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = false
        navigationBar.barTintColor = Colors.DarkBlue
        navigationBar.tintColor = Colors.OffWhite
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            Printer.print("Mail cancelled")
        case .saved:
            Printer.print("Mail saved")
        case .sent:
            Printer.print("Mail sent")
        case .failed:
            Printer.print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        }
        dismiss(animated: true, completion: nil)
    }
}

class MailComposeVC: MFMessageComposeViewController, MFMessageComposeViewControllerDelegate {
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            Printer.print("Message cancelled")
        case .sent:
            Printer.print("Message sent")
        case .failed:
            Printer.print("Message failure")
        }
        dismiss(animated: true, completion: nil)
    }
}
