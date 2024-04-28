//
//  CreateNoteViewController.swift
//  NoteList
//
//  Created by @suonvicheakdev on 28/4/24.
//

import UIKit

class CreateNoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Note"
        
        //configure basic UI
//        detailTextView.borderStyle = .
            
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
    
    @IBAction func viewTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func saveDataButtonClick(_ sender: UIButton) {
        let title = titleTextField.text ?? ""
        let detail = detailTextView.text ?? ""
        
        //validate data
        if validateNote() {
            NotificationCenter.default.post(name: NSNotification.Name.saveData, object: Note(title: title, detail: detail))
            
            let alertController = UIAlertController(title: "Success", message: "A note has been added!",  preferredStyle: .alert)
            let action1 = UIAlertAction(title: "View Notes", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                navigationController?.popViewController(animated: true)
            })
            alertController.addAction(action1)
            present(alertController, animated: true)
        }
    }
    
}

extension CreateNoteViewController {
    
    func validateNote() -> Bool {
        var isValidated: Bool = true
        
        if titleTextField.text == "" {
            isValidated = false

            let alertController = UIAlertController(title: "Error", message: "Please enter note title!",  preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alertController.addAction(action1)
            present(alertController, animated: true)
            titleTextField.becomeFirstResponder()
            detailTextView.resignFirstResponder()
            
            return isValidated
        }
        if detailTextView.text == "" {
            isValidated = false
            
            let alertController = UIAlertController(title: "Error", message: "Please enter node detail!",  preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alertController.addAction(action1)
            present(alertController, animated: true)
            detailTextView.becomeFirstResponder()
            titleTextField.resignFirstResponder()
            
            return isValidated
        }
   
        return isValidated
    }
    
}
