//
//  ViewController.swift
//  TextViewSearch
//
//  Created by Piet Brauer on 05/04/16.
//  Copyright © 2016 nerdish by nature. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var textView: UITextView!
    var keyboardFrame: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView?.becomeFirstResponder()
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ViewController.scrollToSearchResult), userInfo: nil, repeats: false)
    }

    func scrollToSearchResult() {
        let regex = try! NSRegularExpression(pattern: "dolore", options: .CaseInsensitive)
        let matches = regex.matchesInString(textView.text, options: .ReportProgress, range: NSRange(location: 0, length: textView.text.characters.count))
        if let lastRange = matches.last?.range { // Should match the last line
            textView.scrollRangeToVisible(lastRange)
            textView.selectedRange = lastRange
        }
    }

    func setupObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        let infoKeyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue

        let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        let kbFrame = infoKeyboardFrame?.CGRectValue()
        let finalKeyboardFrame = view.convertRect(kbFrame ?? CGRectZero, toView: view.window)
        self.keyboardFrame = finalKeyboardFrame

        view.setNeedsLayout()
        UIView.animateWithDuration(animationDuration ?? 0) { 
            self.view.layoutIfNeeded()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let textView = textView {
            let insets = textView.contentInset
            textView.contentInset = UIEdgeInsets(top: insets.top, left: insets.left, bottom: keyboardFrame?.height ?? 0, right: insets.right)
            let scrollIndicatorInsets = textView.scrollIndicatorInsets
            textView.scrollIndicatorInsets = UIEdgeInsets(top: scrollIndicatorInsets.top, left: scrollIndicatorInsets.left, bottom: keyboardFrame?.height ?? 0, right: scrollIndicatorInsets.right)
        }
    }
}

