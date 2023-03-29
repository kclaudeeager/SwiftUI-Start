//
//  Order.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct Order: Decodable, Hashable, Identifiable, Equatable {
    let id: String // Change the type to String
    var tableNumber: String
    var serverId: Int
    var status: String
    var totalAmount: String
    let createdAt: String
    var updatedAt: String
    var orderItems: [OrderItem]
    
    static func ==(lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id && lhs.orderItems == rhs.orderItems && lhs.tableNumber==rhs.tableNumber && lhs.totalAmount==rhs.totalAmount && lhs.updatedAt==rhs.updatedAt && lhs.status==rhs.status
        }
}
