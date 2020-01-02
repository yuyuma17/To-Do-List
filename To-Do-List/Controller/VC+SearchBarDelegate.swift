//
//  VC+SearchBarDelegate.swift
//  To-Do-List
//
//  Created by 黃士軒 on 2019/12/25.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import UIKit

extension TodoListViewController: UISearchBarDelegate {
    
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
