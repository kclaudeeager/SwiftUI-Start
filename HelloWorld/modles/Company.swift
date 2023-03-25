//
//  Company.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/10/23.
//

import Foundation

struct Company: Decodable,Hashable{
    let cpy_ID: String
    let cmp_sn: String
    let cmp_full: String?
    let phone: String
    let address: String
}
