//
//  User.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/10/23.
//

import Foundation

struct User: Decodable,Hashable {
    let acc_id: String
    let l_name: String
    let f_name: String
    let email: String
    let role_id: String
    let co_id: String
    let site_id: String
    let dep_id: String
    let mobile: String

}
