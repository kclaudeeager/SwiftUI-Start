//
//  CartButton.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
import SwiftUI
struct CartButton: View {
    var totalCartItems: Int
    @Binding var cartItems: [CartItem] // added cart parameter
    let accompaniments:[Accompaniment]
    let sauces:[Sauce]
    let serviceTables: [ServiceTable]
    var body: some View {
        NavigationLink(destination: CheckoutView(cartItems:$cartItems,accompaniments: accompaniments,sauces:sauces,serviceTables:serviceTables)) { // pass cart to CheckoutView
            HStack(spacing: 10) {
                ZStack {
                    Image(systemName: "cart")
                    Text("\(totalCartItems)")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .padding(4)
                        .background(Circle().foregroundColor(.red))
                        .offset(x: 10, y: -10)
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color.blue)
                .cornerRadius(10)
                
                Text("Checkout")
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            }
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}




