//
//  ItemPriceResponse.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/28/23.
//

import Foundation

struct ItemPriceResponse: Decodable {
    let item: String
    let amount: String
    let message: String
    let unit_name: String
}
