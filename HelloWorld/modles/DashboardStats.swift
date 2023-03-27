//
//  DashboardStats.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
struct DashboardStats:Decodable,Hashable {
       let pending: Int
       let inProgress: Int
       let delivered: Int
       let totalAmount: Int
}
