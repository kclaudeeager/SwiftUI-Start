//
//  Accompaniment.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation

struct Accompaniment: Decodable, Hashable {
    let id: String
    let name: String
    let siteId: String
    let status: String
    let deleteFlag: String

    enum CodingKeys: String, CodingKey {
        case id = "accm_id"
        case name = "accm_name"
        case siteId = "site_id"
        case status = "status"
        case deleteFlag = "delete_flag"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.siteId = try container.decode(String.self, forKey: .siteId)
        self.status = try container.decode(String.self, forKey: .status)
        self.deleteFlag = try container.decode(String.self, forKey: .deleteFlag)
    }

    init(id: String="", name: String="", siteId: String="", status: String="", deleteFlag: String="") {
        self.id = id
        self.name = name
        self.siteId = siteId
        self.status = status
        self.deleteFlag = deleteFlag
    }
}

