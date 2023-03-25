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
   
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.itemId = try container.decode(String.self, forKey: .itemId)
        self.itemName = try container.decode(String.self, forKey: .itemName)
        self.classItem = try container.decode(String.self, forKey: .classItem)
        self.siteId = try container.decode(String.self, forKey: .siteId)
        self.depId = try container.decode(String.self, forKey: .depId)
        self.regDate = try container.decode(String.self, forKey: .regDate)
        self.status = try container.decode(String.self, forKey: .status)
        self.deleteFlag = try container.decode(String.self, forKey: .deleteFlag)
    }
    
    init(itemId: String = "", itemName: String = "", classItem: String = "", siteId: String = "", depId: String = "", regDate: String = "", status: String = "", deleteFlag: String = "") {
        self.itemId = itemId
        self.itemName = itemName
        self.classItem = classItem
        self.siteId = siteId
        self.depId = depId
        self.regDate = regDate
        self.status = status
        self.deleteFlag = deleteFlag
    }

}
