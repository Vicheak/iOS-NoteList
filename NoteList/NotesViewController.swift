//
//  NotesViewController.swift
//  NoteList
//
//  Created by @suonvicheakdev on 28/4/24.
//

import UIKit

struct Note {
    let title: String
    let detail: String
}

class NotesViewController: UIViewController {
    
    var notes = [Note]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        //add the bar button item to bar button group
        self.navigationItem.rightBarButtonItems?.append(self.editButtonItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataNotification), name: NSNotification.Name.saveData, object: nil)
    }
    
    @objc func saveDataNotification(notification: Notification) {
        guard let note = notification.object as? Note else { return }
     
        updateDataSource(note: note)
    }

    @IBAction func addButtonClick(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createNoteViewController: CreateNoteViewController = storyboard.instantiateViewController(withIdentifier: "CreateNoteViewController") as! CreateNoteViewController
        
        createNoteViewController.onSave = { [weak self] note in
            guard let self = self else { return }
            self.updateDataSource(note: note)
        }
        
        createNoteViewController.delegate = self
        
        navigationController?.pushViewController(createNoteViewController, animated: true)
    }
    
}

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        let note = notes[indexPath.item]
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.detail
        return cell
    }
    
    //for enabling row editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //for move cell or row
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

extension NotesViewController {
    func updateDataSource(note: Note) {
        notes.append(note)
//        tableView.reloadData()
        tableView.insertRows(at: [IndexPath(row: notes.count - 1, section: 0)], with: .automatic)
    }
}

extension NotesViewController: CreateNoteDelegate {
    func saveData(note: Note) {
        updateDataSource(note: note)
    }
}

extension NSNotification.Name {
    static let saveData = NSNotification.Name.init("saveData")
}
