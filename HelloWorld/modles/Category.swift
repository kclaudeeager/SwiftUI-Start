//
//  Category.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct Category:Decodable,Hashable {
      let itemId: String
       let itemName: String
       let classItem: String
       let siteId: String
       let depId: String
       let regDate: String
       let status: String
       let deleteFlag: String
}
