//
//  ViewController.swift
//  SFCredentialHacker
//
//  Created by Peter Park on 10/30/15.
//  Copyright © 2015 Rollio. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var credentialLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    
    var credentials: Dictionary<String, String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedSFCredentials:", name: SFCredentialsReceivedNotification, object: nil)
    }
    
    @IBAction func emailButtonTapped(sender: UIButton) {
        
        guard let cred = credentials else {
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setSubject("Salesforce credential information")
        mailComposer.setMessageBody(cred.description, isHTML: false)
        
        self.presentViewController(mailComposer, animated: true, completion: nil)
    }
    
    func receivedSFCredentials(notification: NSNotification) {
        credentials = notification.object as? Dictionary<String, String>
        
        guard let cred = credentials else {
            return
        }
        
        credentialLabel.text = cred.description
        
        if MFMailComposeViewController.canSendMail() {
            emailButton.enabled = true
        }
    }
    
    
    // MARK: - MFMailComposeViewController delegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

