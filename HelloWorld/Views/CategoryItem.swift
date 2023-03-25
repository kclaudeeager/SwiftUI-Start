//
//  CategoryItem.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
import SwiftUI
struct CategoryItem: View {
    var name: String
    
    var body: some View {
        Text(name)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.trailing, 10)
    }
}

