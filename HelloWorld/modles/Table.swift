//
//  Table.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct Tabel:Decodable,Hashable{
    let number: String
     let orders: [Order]
}
