//
//  AccompanimentSauceResponse.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation

struct AccompanimentSauceResponse:Decodable {
    let accompaniments: [Accompaniment]
    let sauces: [Sauce]
}
