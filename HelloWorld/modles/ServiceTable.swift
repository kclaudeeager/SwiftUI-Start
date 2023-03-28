//
//  ServiceTable.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct ServiceTable: Decodable,Equatable {
    let id: String
    let number: String
    let siteId: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id = "tbl_id"
        case number = "tbl_no"
        case siteId = "site_id"
        case status = "status"
    }
    static func ==(lhs: ServiceTable, rhs: ServiceTable) -> Bool {
            return lhs.id == rhs.id && lhs.number == rhs.number
        }
}

