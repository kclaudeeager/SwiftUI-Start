//
//  Table.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct TabelOrder:Decodable,Hashable,Identifiable{
     let number: String
     let orders: [Order]
    var id: String {
        number
    }
}
