//
//  CategoriesResponse.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct CategoriesResponse: Decodable {
    let categories: [Category]

    enum CodingKeys: String, CodingKey {
        case categories = "items"
    }
}

