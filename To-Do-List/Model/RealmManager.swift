//
//  RealmManager.swift
//  To-Do-List
//
//  Created by 黃士軒 on 2019/12/24.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import RealmSwift

class RealmManager {
    
    let realm = try! Realm()
    var datas: Results<Data>?
    
    static let shared = RealmManager()
    
    func saveData(_ data: Data, reload tableView: UITableView) {
        
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(reload tableView: UITableView) {
        
        datas = realm.objects(Data.self).sorted(byKeyPath: "done", ascending: true)
        tableView.reloadData()
    }
    
    func changeDataStatus(_ data: Data, reload tableView: UITableView) {
        
        do {
              try realm.write {
                  data.done = !data.done
              }
          } catch {
              print("Error changing data \(error)")
          }
          tableView.reloadData()
    }
    
    func deleteData(_ data: Data, at indexPath: IndexPath, in tableView: UITableView) {
        
        do {
              try realm.write {
                realm.delete(data)
              }
          } catch {
              print("Error changing data \(error)")
          }
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func reviseData(_ data: Data, task: String, reload tableView: UITableView) {
        
        do {
              try realm.write {
                data.task = task
              }
          } catch {
              print("Error changing data \(error)")
          }
        tableView.reloadData()
    }
}
