//
//  VC+TableViewDataSource.swift
//  To-Do-List
//
//  Created by 黃士軒 on 2020/1/2.
//  Copyright © 2020 黃士軒. All rights reserved.
//

import UIKit

extension TodoListViewController: UITableViewDataSource {
    
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
}
