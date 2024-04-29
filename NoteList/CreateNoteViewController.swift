//
//  CreateNoteViewController.swift
//  NoteList
//
//  Created by @suonvicheakdev on 28/4/24.
//

import UIKit

protocol CreateNoteDelegate {
    func saveData(note: Note)
}

class CreateNoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //create a closure to make a callback signal when clicking save button
    var onSave: ((Note) -> Void)?
    
    var delegate: CreateNoteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Note"
        
        //configure basic UI
        //...
            
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
            let alertController = UIAlertController(title: "Success", message: "A note has been added!",  preferredStyle: .alert)
            let action1 = UIAlertAction(title: "View Notes", style: .default, handler: { [weak self] _ in
                //use a callback function to pop the view controller
                guard let self = self else { return }
                
//                NotificationCenter.default.post(name: NSNotification.Name.saveData, object: Note(title: title, detail: detail))
                
                let note: Note = Note(title: title, detail: detail)
                
                //call a closure for a callback signal
//                onSave?(note)
                
                //use a delegate to make a callback when invoking the method from the class
                //which owns the delegate property
                delegate?.saveData(note: note)
                
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
            
            let alertController = UIAlertController(title: "Error", message: "Please enter note detail!",  preferredStyle: .alert)
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
