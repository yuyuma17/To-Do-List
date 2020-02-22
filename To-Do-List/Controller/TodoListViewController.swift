//
//  TodoListViewController.swift
//  To-Do-List
//
//  Created by 黃士軒 on 2020/1/2.
//  Copyright © 2020 黃士軒. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UIViewController {

    fileprivate let realmManager = RealmManager.shared
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        searchBar.autocapitalizationType = .none
        realmManager.loadData(reload: tableView)
    }
    
    @IBAction func addNewTaskButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Task", message: nil, preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (field) in
            field.placeholder = "Write Something..."
            textField = field
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            let data = Data()
            data.task = textField.text!
            self.realmManager.saveData(data, reload: self.tableView)
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return realmManager.datas?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        if let data = realmManager.datas?[indexPath.row] {
            cell.textLabel?.text = data.task
            cell.accessoryType = data.done ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let data = realmManager.datas?[indexPath.row] {
            realmManager.changeDataStatus(data, reload: tableView)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if tableView.isEditing == false {
            tableView.isEditing = true
            navigationItem.leftBarButtonItem?.title = "Done"
        } else {
            tableView.isEditing = false
            navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let self = self else { return }
            
            if let data = self.realmManager.datas?[indexPath.row] {
                self.realmManager.deleteData(data, at: indexPath, in: tableView)
            }
        }
        let edit = UIContextualAction(style: .normal, title: "Revise") { [weak self] (_, _, _) in
            guard let self = self else { return }
            
            let alert = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
            
            var textField = UITextField()
            
            alert.addTextField { (field) in
                field.placeholder = "Write Something..."
                textField = field
                textField.text = self.realmManager.datas?[indexPath.row].task
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
                guard let self = self else { return }
                
                if let data = self.realmManager.datas?[indexPath.row] {
                    self.realmManager.reviseData(data, task: textField.text!, reload: tableView)
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }
        edit.backgroundColor = UIColor.systemGreen
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            realmManager.loadData(reload: tableView)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            realmManager.datas = realmManager.datas?.filter("task CONTAINS[cd] %@", searchBar.text!)
            tableView.reloadData()
        }
    }
}
