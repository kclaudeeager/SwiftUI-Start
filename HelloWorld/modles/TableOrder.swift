//
//  Table.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct TabelOrder: Decodable, Hashable, Identifiable {
    let number: String
    let orders: [Order]

    var id: String {
        number
    }

    enum CodingKeys: String, CodingKey {
        case number = "table_number"
        case orders
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try container.decode(String.self, forKey: .number)
        orders = try container.decode([Order].self, forKey: .orders)
    }
    
    init(number: String, orders: [Order]) {
        self.number = number
        self.orders = orders
    }
}

