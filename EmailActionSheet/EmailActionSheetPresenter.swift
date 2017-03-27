//
//  EmailActionSheetPresenter.swift
//  EmailActionSheet
//
//  Created by Harry Bloom on 22/03/2017.
//  Copyright © 2017 WeVat. All rights reserved.
//

import UIKit

protocol ChooseEmailActionSheetPresenter {
    
    var chooseEmailActionSheet: UIAlertController? { get }
    
    func setupChooseEmailActionSheet(withTitle title: String?, withFrom emailString: String?, withSubject subjectString: String?) -> UIAlertController
}

extension ChooseEmailActionSheetPresenter {
    
    func setupChooseEmailActionSheet(withTitle title: String? = "Choose Email", withFrom emailString: String? = nil, withSubject subjectString: String? = nil) -> UIAlertController {
        
        let emailActionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let escapedSubjectString = subjectString?.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        let actionArray = populateAppActionArray(withEmailString: emailString, escapedSubjectString: escapedSubjectString)
        
        if actionArray.count == 0, let safariAction = openSafariAction() {
            emailActionSheet.addAction(safariAction)
        } else {
            actionArray.forEach({ action in
                emailActionSheet.addAction(action)
            })
        }
        
        emailActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return emailActionSheet
    }
    
}

extension ChooseEmailActionSheetPresenter {
    
    fileprivate func populateAppActionArray(withEmailString emailString: String?, escapedSubjectString: String?) -> [UIAlertAction] {
        
        var actionArray = [UIAlertAction]()
        
        if let gmail = openGmailSupportAction(withFrom: emailString, withSubject: escapedSubjectString) {
            actionArray.append(gmail)
        }
        
        if let inbox = openInboxSupportAction(withFrom: emailString, withSubject: escapedSubjectString) {
            actionArray.append(inbox)
        }
        
        if let outlookUrl = openOutlookSupportAction(withFrom: emailString, withSubject: escapedSubjectString) {
            actionArray.append(outlookUrl)
        }
        
        if let dispatchUrl = openDispatchSupportAction(withFrom: emailString, withSubject: escapedSubjectString) {
            actionArray.append(dispatchUrl)
        }
        
        if let mailUrl = openMailSupportAction(withFrom: emailString, withSubject: escapedSubjectString) {
            actionArray.append(mailUrl)
        }
        
        return actionArray
    }
    
    
    fileprivate func openGmailSupportAction(withFrom: String?, withSubject: String?) -> UIAlertAction? {
        
        var gmailUrlString = "googlegmail:///"
        
        if let from = withFrom {
            gmailUrlString += "co?to=\(from)"
        }
        
        if let subject = withSubject {
            gmailUrlString += "&subject=\(subject)"
        }
        
        return openAction(withURL: gmailUrlString, andTitleActionTitle: "Gmail")
    }
    
    fileprivate func openInboxSupportAction(withFrom: String?, withSubject: String?) -> UIAlertAction? {
        
        var inboxUrlString = "inbox-gmail://"
        
        if let from = withFrom {
            inboxUrlString += "co?to=\(from)"
        }
        
        if let subject = withSubject {
            inboxUrlString += "&subject=\(subject)"
        }
        
        return openAction(withURL: inboxUrlString, andTitleActionTitle: "Inbox")
    }
    
    fileprivate func openOutlookSupportAction(withFrom: String?, withSubject: String?) -> UIAlertAction? {
        
        var mailUrlString = "ms-outlook://"
        
        if let from = withFrom {
            mailUrlString += "compose?to=\(from)"
        }
        
        if let subject = withSubject {
            mailUrlString += "&subject=\(subject)"
        }
        
        return openAction(withURL: mailUrlString, andTitleActionTitle: "Outlook")
    }
    
    fileprivate func openDispatchSupportAction(withFrom: String?, withSubject: String?) -> UIAlertAction? {
        
        var dispatchUrlString = "x-dispatch:///"
        
        if let from = withFrom {
            dispatchUrlString += "compose?from=\(from)"
        }
        
        if let subject = withSubject {
            dispatchUrlString += "&subject=\(subject)"
        }
        
        return openAction(withURL: dispatchUrlString, andTitleActionTitle: "Dispatch")
    }
    
    fileprivate func openMailSupportAction(withFrom: String?, withSubject: String?) -> UIAlertAction? {
        
        var mailUrlString = "mailto:"
        
        if let from = withFrom {
            mailUrlString += "\(from)"
        }
        
        if let subject = withSubject {
            mailUrlString += "?subject=\(subject)"
        }
        
        return openAction(withURL: mailUrlString, andTitleActionTitle: "Mail")
    }
    
    fileprivate func openSafariAction() -> UIAlertAction? {
        
        guard let url = URL(string: "http://www.google.com") else { return nil }
        
        let safariAction = UIAlertAction(title: "Open with Safari", style: .default) { (action) in
            
            UIApplication.shared.openURL(url)
        }
        
        return safariAction
    }
    
    fileprivate func openAction(withURL: String, andTitleActionTitle: String) -> UIAlertAction? {
        
        guard let url = URL(string: withURL), UIApplication.shared.canOpenURL(url) else {
            return nil
        }
        
        let action = UIAlertAction(title: andTitleActionTitle, style: .default) { (action) in
            
            UIApplication.shared.openURL(url)
        }
        
        return action
    }
}
