//
//  MenuItem.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct MenuItem: Decodable, Hashable, Identifiable {
    let assign_id: String
    let item: String
    let catg_id: String
    let unit_id: String
    let image: String?
    let site_id: String
    let dep_id: String
    let has_parent: String?
    let piece_no: String?
    let orderable: String?
    let type: String
    let status: String
    let catg_name: String
    let item_id: String
    let item_name: String
    let class_item: String
    let reg_date: String
    let delete_flag: String
    let unit_name: String
    let price: String 
    var isChecked: Bool = false
    
    var id: String {
        assign_id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(assign_id)
    }
    
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.assign_id == rhs.assign_id
    }
    
    enum CodingKeys: String, CodingKey {
            case assign_id
            case item
            case catg_id
            case unit_id
            case image
            case site_id
            case dep_id
            case has_parent
            case piece_no
            case orderable
            case type
            case status
            case catg_name
            case item_id
            case item_name
            case class_item
            case reg_date
            case delete_flag
            case unit_name
            case price
        }
    
}
