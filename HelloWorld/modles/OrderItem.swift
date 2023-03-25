//
//  OrderItem.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct OrderItem:Decodable,Hashable {
      var id:Int=0
       var assign_id:Int=0
       let orderId: Int
       var quantity: Int
       let price: Double
       var status:String="pending"
}
