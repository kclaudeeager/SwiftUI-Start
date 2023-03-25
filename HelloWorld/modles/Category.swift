//
//  Category.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct Category: Decodable, Hashable {
    let itemId: String
    let itemName: String
    let classItem: String
    let siteId: String
    let depId: String
    let regDate: String
    let status: String
    let deleteFlag: String
    
    enum CodingKeys: String, CodingKey {
        case itemId = "item_id"
        case itemName = "item_name"
        case classItem = "class_item"
        case siteId = "site_id"
        case depId = "dep_id"
        case regDate = "reg_date"
        case status = "status"
        case deleteFlag = "delete_flag"
    }
   

}
