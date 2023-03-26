//
//  CartItemView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/26/23.
//

import Foundation

import SwiftUI

struct CartItemView: View {
    let cartItem: CartItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(cartItem.menuItem.unit_name == "" ? "\(cartItem.menuItem.catg_name)" : "\(cartItem.menuItem.catg_name) _ \(cartItem.menuItem.unit_name)")
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                    .lineLimit(2)
                    .padding(.top, 4)
                    .multilineTextAlignment(.center)
                Spacer()
                Text(String(format: "%.1f RWF", cartItem.consumed_amount))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
            HStack(spacing: 8) {
                Text("Qty: \(cartItem.quantity)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                })
                Button(action: {}, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.green)
                })
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


