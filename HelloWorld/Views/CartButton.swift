//
//  CartButton.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
import SwiftUI
struct CartButton: View {
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "cart")
                Text("Checkout")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
