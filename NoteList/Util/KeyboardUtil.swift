//
//  KeyboardUtil.swift
//  NoteList
//
//  Created by @suonvicheakdev on 4/5/24.
//

import UIKit

class KeyboardUtil {
    
    var view: UIView
    var bottomConstraint: NSLayoutConstraint
    
    init(view: UIView, bottomConstraint: NSLayoutConstraint) {
        self.view = view
        self.bottomConstraint = bottomConstraint
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(notification: Notification) {
        guard let size = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        bottomConstraint.constant = size.height
        view.layoutIfNeeded()
    }
    
    @objc func hideKeyboard() {
        bottomConstraint.constant = 0
        view.layoutIfNeeded()
    }

}
