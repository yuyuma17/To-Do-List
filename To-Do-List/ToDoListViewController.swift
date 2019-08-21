//
//  ViewController.swift
//  To-Do-List
//
//  Created by 黃士軒 on 2019/8/7.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    
    //建一個array來放待辦事項，而且要可以變動----------------------------------------------
    var toDoArray : [String] = ["Do an App"]
    //宣告使用userDefaults------------------------------------------------------------
    let defaults = UserDefaults.standard
    
    
    //預先載入的地方，在這裡重新讀取已儲存的userDefaults------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //不要crash然後載入已儲存的userDefaults
        if let noCrash = defaults.array(forKey: "toDoArray") as? [String] {
            toDoArray = noCrash
        }
        
        //使用原生的editButton
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        editButtonItem.title = "編輯"
    }

    
    //回傳Section Row的數量-----------------------------------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    
    //回傳Cell及顯示輸入的內容----------------------------------------------------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        cell.textLabel?.text = toDoArray[indexPath.row]
        
        return cell
    }
    
    
    //使用userDefaults儲存資料--------------------------------------------------------
    func saveToDoArrayAndReloadData() {
        self.defaults.set(self.toDoArray, forKey: "toDoArray")
        self.tableView.reloadData()
    }

    
    //反灰太久了把它改一下--------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    //把addAlert相關系列功能給包起來----------------------------------------------------
    func showAddAlert() {
        
        var addTextField = UITextField()
        
        //新增的按鈕以alert形式呈現
        let addAlert = UIAlertController(title: "新增待辦事項", message: "", preferredStyle: .alert)
        
        //新增的按鈕、將textField裡的字新增到toDoArray裡、將資料存到userDefaults裡（字數大於1及不是空白才能存)
        let addAction = UIAlertAction(title: "新增", style: .default) { (UIAlertAction) in
            
            if addTextField.text!.count >= 1 {
                self.toDoArray.append(addTextField.text!)
                self.saveToDoArrayAndReloadData()
            }
        }
        
        //取消的按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        //alert裡面新增textField並輸入你要新增的待辦事項
        addAlert.addTextField { (UITextField) in
            UITextField.placeholder = "快寫下來不然你會忘記"
            addTextField = UITextField
        }
        
        //呈現alert及alertAction
        addAlert.addAction(addAction)
        addAlert.addAction(cancelAction)
        present(addAlert, animated: true, completion: nil)
    }
    
    
    //新增功能的實作------------------------------------------------------------------
    @IBAction func newToDoThings(_ sender: UIBarButtonItem) {

        showAddAlert()
    }
    
    
    //進入編輯狀態及左滑顯示刪除---------------------------------------------------------
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //將button修改成中文、加入隱藏新增按鈕的機制-------------------------------------------
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if(editing) {
            editButtonItem.title = "完成"
            navigationItem.title = "編輯模式"
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        else {
            editButtonItem.title = "編輯"
            navigationItem.title = "待辦事項"
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    
    //實作移動順序的功能----------------------------------------------------------------
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //移動順序後也改變陣列裡的順序並存進userDefaults裡，不然每次重開都會回歸原處-----------------
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let sequence = toDoArray[sourceIndexPath.row]
        toDoArray.remove(at: sourceIndexPath.row)
        toDoArray.insert(sequence, at: destinationIndexPath.row)
        
        saveToDoArrayAndReloadData()
    }
    
    
    //實作刪除及修改的功能---------------------------------------------------------------
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //刪除功能實作，並存進userDefaults裡
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "刪除") { (UITableViewRowAction, IndexPath) in
            
            self.toDoArray.remove(at: indexPath.row)
            self.saveToDoArrayAndReloadData()
        }
        
        //修改功能實作
        let editAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "修改") { (UITableViewRowAction, IndexPath) in
            
            var editTextField = UITextField()
            
            //修改的按鈕以alert形式呈現
            let editAlert = UIAlertController(title: "修改待辦事項", message: "", preferredStyle: .alert)
            
            //修改的按鈕、將textField裡的字修改到toDoArray裡、將資料存到userDefaults裡（字數大於1及不是空白才能存)
            let reviseAction = UIAlertAction(title: "修改", style: .default) { (UIAlertAction) in
                
                if editTextField.text!.count >= 1 {
                    
                    self.toDoArray[indexPath.row] = editTextField.text!
                    self.saveToDoArrayAndReloadData()
                }
            }
            
            //alert裡面新增textField並輸入你要修改的待辦事項
            editAlert.addTextField { (UITextField) in
                UITextField.placeholder = "快寫下來不然你會忘記"
                editTextField = UITextField
                editTextField.text = self.toDoArray[indexPath.row]
            }
            
            //取消的按鈕
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            //呈現alert及alertAction
            editAlert.addAction(reviseAction)
            editAlert.addAction(cancelAction)
            self.present(editAlert, animated: true, completion: nil)
        }
        
        return [deleteAction, editAction]
    }
}
