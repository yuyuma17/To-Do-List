//
//  VC+TableViewDelegate.swift
//  To-Do-List
//
//  Created by 黃士軒 on 2020/1/2.
//  Copyright © 2020 黃士軒. All rights reserved.
//

import UIKit

extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let data = realmManager.datas?[indexPath.row] {
            realmManager.changeDataStatus(data, reload: tableView)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
