//
//  Data.swift
//  To-Do-List
//
//  Created by 黃士軒 on 2019/11/2.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var task = ""
    @objc dynamic var done = false
    @objc dynamic var createDate = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
