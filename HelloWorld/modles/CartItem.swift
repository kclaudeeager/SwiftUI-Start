//
//  CartItem.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation

struct CartItem:Decodable,Hashable {
       let menuItem: MenuItem
       var quantity: Int
       var consumed_amount: Float
       let accompaniment: Accompaniment?
       let sauce: Sauce?
       let comment: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(menuItem.assign_id)
        }

        static func == (lhs: CartItem, rhs: CartItem) -> Bool {
            return lhs.menuItem.assign_id == rhs.menuItem.assign_id && lhs.consumed_amount==rhs.consumed_amount
        }
}
