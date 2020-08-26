//
//  Category.swift
//  Todoey
//
//  Created by 1 on 8/20/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object {
    
  @objc dynamic var name:String = ""
  let items = List<Item>()
}
