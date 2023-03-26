//
//  CheckoutView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/26/23.
//

import Foundation
import SwiftUI



struct CheckoutView: View {
    let cartItems: [CartItem]
    
    var body: some View {
        VStack(spacing:20){
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 16) {
                    ForEach(cartItems, id: \.menuItem.assign_id) { cartItem in
                        CartItemView(cartItem:cartItem)
                    }
                }
                .padding(16)
            }
            
        }
        .navigationTitle("Checkout")
    }
}


