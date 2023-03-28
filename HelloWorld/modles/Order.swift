//
//  Order.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct Order:Decodable,Hashable,Identifiable {
       let id: Int
       let tableNumber: String
       let serverId: Int
       let status: String
       let totalAmount: Double
       let createdAt: String
       let updatedAt: String
       let orderItems: [OrderItem]
}
