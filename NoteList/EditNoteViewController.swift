//
//  EditNoteViewController.swift
//  NoteList
//
//  Created by @suonvicheakdev on 4/5/24.
//

import UIKit

class EditNoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
//    private var note: Note!
    var note: Note!
    
    var delegate: CreateNoteDelegate?
    
    var keyboardUtil: KeyboardUtil!
    
    static func initWith(note: Note) -> EditNoteViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editNoteViewController = storyboard.instantiateViewController(withIdentifier: "EditNoteViewController") as! EditNoteViewController
        
        editNoteViewController.note = note
        return editNoteViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        detailTextView.delegate = self
        
        //configure keyboard util
        keyboardUtil = KeyboardUtil(view: self.view, bottomConstraint: self.bottomConstraint)
        
        titleTextField.text = note.title
        detailTextView.text = note.detail
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
    
    @IBAction func viewTab(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func editTap(_ sender: Any) {
        let title = titleTextField.text ?? ""
        let detail = detailTextView.text ?? ""
        
        if validateNote() {
            delegate?.updateData(note: Note(id: note.id, title: title, detail: detail))
            navigationController?.popViewController(animated: true)
        }
    }

}

extension EditNoteViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            detailTextView.becomeFirstResponder()
        } else {
            detailTextView.resignFirstResponder()
        }
        
        return true
    }
    
}

extension EditNoteViewController {
    
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
