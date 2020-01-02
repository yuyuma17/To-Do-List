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

    let realmManager = RealmManager.shared
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realmManager.loadData(reload: tableView)
    }
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        
        showAlert("test", "OK", nil)
    }
}

extension TodoListViewController {
    
    func showAlert(_ alertTitle: String, _ confirmActionTitle: String, _ handler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: confirmActionTitle, style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        var textField = UITextField()
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Write Something here..."
            textField = UITextField
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
