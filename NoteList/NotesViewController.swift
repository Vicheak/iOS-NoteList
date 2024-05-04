//
//  NotesViewController.swift
//  NoteList
//
//  Created by @suonvicheakdev on 28/4/24.
//

import UIKit

struct Note: Equatable {
    let id: UUID
    let title: String
    let detail: String
    
    init(id: UUID, title: String, detail: String) {
        self.id = id
        self.title = title
        self.detail = detail
    }
    
    init(title: String, detail: String) {
        self.id = UUID()
        self.title = title
        self.detail = detail
    }
}

class NotesViewController: UIViewController {
    
    var notes = [Note(title: "test", detail: "detail"),
                 Note(title: "test", detail: "detail"),
                 Note(title: "test", detail: "detail"),
                 Note(title: "test", detail: "detail"),
                 Note(title: "test", detail: "detail"),
                 Note(title: "test", detail: "detail")]

    @IBOutlet weak var tableView: UITableView!
    
    var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        //add the bar button item to bar button group
//        self.navigationItem.rightBarButtonItems?.append(self.editButtonItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataNotification), name: NSNotification.Name.saveData, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? CreateNoteViewController {
            viewController.delegate = self
        } else if let viewController = segue.destination as? EditNoteViewController {
            viewController.note = selectedNote
            viewController.delegate = self
        }
    }
    
    @objc func saveDataNotification(notification: Notification) {
        guard let note = notification.object as? Note else { return }
     
        updateDataSource(note: note)
    }

//    @IBAction func addButtonClick(_ sender: UIBarButtonItem) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let createNoteViewController: CreateNoteViewController = storyboard.instantiateViewController(withIdentifier: "CreateNoteViewController") as! CreateNoteViewController
//        
//        createNoteViewController.onSave = { [weak self] note in
//            guard let self = self else { return }
//            self.updateDataSource(note: note)
//        }
//        
//        createNoteViewController.delegate = self
//        
//        navigationController?.pushViewController(createNoteViewController, animated: true)
//    }
    
}

extension NotesViewController: UITableViewDataSource {
    
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

}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, complete in
            let alertController = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "OK", style: .destructive) { _ in
                self?.deleteNote(at: indexPath)
                complete(true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                complete(true)
            }
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self?.present(alertController, animated: true)
//            self?.present(alertController, animated: true, completion: {
//                complete(true)
//            })
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, complete in
            self?.editNote(at: indexPath)
            
            complete(true)
        }
        editAction.backgroundColor = .green
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func deleteNote(at indexPath: IndexPath) {
        notes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func editNote(at indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let editNoteViewController: CreateNoteViewController = storyboard.instantiateViewController(withIdentifier: "CreateNoteViewController") as! CreateNoteViewController
//        let note = notes[indexPath.row]
//        
//        editNoteViewController.note = note
        
//        let note = notes[indexPath.row]
//        let editNoteViewController = EditNoteViewController.initWith(note: note)
//        
//        editNoteViewController.delegate = self
//        navigationController?.pushViewController(editNoteViewController, animated: true)
        
        let note = notes[indexPath.row]
        selectedNote = note
        
        performSegue(withIdentifier: "editNote", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        }
        return 100;
    }
    
    //for enabling row editing
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            notes.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    //for move cell or row
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
}

extension NotesViewController {
    func updateDataSource(note: Note) {
        notes.append(note)
//        tableView.reloadData()
        tableView.insertRows(at: [IndexPath(row: notes.count - 1, section: 0)], with: .automatic)
    }
}

extension NotesViewController: CreateNoteDelegate {
    func updateData(note: Note) {
        if let index = notes.firstIndex(where: { n in
            n.id == note.id
        }) {
            notes[index] = note
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//            print("note has been updated!")
        } else {
            notes.append(note)
            tableView.insertRows(at: [IndexPath(row: notes.count - 1, section: 0)], with: .automatic)
//            print("a new note has been created!")
        }
        
//        if let index = notes.firstIndex(where: {
//            $0.id == note.id
//        }) {
//            
//        }
    }
    
    func updateData(old: Note, note: Note) {
        if let index = notes.firstIndex(where: { note in
            note == old
        }) {
            notes[index] = note
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        } else {
            notes.append(note)
            tableView.insertRows(at: [IndexPath(row: notes.count - 1, section: 0)], with: .automatic)
        }
    }
    
    func saveData(note: Note) {
        updateDataSource(note: note)
    }
}

extension NSNotification.Name {
    static let saveData = NSNotification.Name.init("saveData")
}
