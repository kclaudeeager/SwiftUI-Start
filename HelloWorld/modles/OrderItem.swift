//
//  OrderItem.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct OrderItem: Decodable, Hashable, Identifiable,Equatable {
    var id: Int = 0
    var assign_id: Int = 0
    var orderId: Int
    var quantity: Int
    let price: Double
    var status: String = "pending"
    var table_number: String
    
    enum CodingKeys: String, CodingKey {
        case id, assign_id, quantity, price, status,table_number
        
        case orderId = "order_id"
    }
    static func ==(lhs: OrderItem, rhs: OrderItem) -> Bool {
        return lhs.id==rhs.id && lhs.status==rhs.status && lhs.quantity==rhs.quantity
    }
}

