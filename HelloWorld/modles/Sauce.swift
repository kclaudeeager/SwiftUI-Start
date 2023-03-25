//
//  Sauce.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct Sauce:Decodable,Hashable {
    
       let id: String
       let name: String
       let siteId: String
       let status: String
       let deleteFlag: String
}
