//
//  AddItemToOrderView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/28/23.
//

import Foundation

import SwiftUI
struct AddItemToOrderView: View {
    let menuItems: [MenuItem]
    @Binding var cart: [CartItem]
    @Binding var selectedTableNumber: String?
    @Binding var showAlert: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Text("Add Item to Order")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 16)
            
            if let tableNumber = selectedTableNumber {
                Text("Table: \(tableNumber)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
            }
            
            MenuGrid(menuList: menuItems, cart: $cart) { item in
                addItemToCart(item: item)
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    showAlert = true
                }, label: {
                    Text("Cancel")
                })
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 8))
                
                Spacer()
                
                Button(action: {
                    onDismiss()
                }, label: {
                    Text("Done")
                        .foregroundColor(.white)
                })
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 16, trailing: 16))
                .background(Color.green)
                .cornerRadius(8)
                .disabled(cart.isEmpty || selectedTableNumber == nil)
            }
        }
        .background(Color(UIColor.systemBackground))
    }
    
    private func addItemToCart(item: MenuItem) {
        if  let itemPrice=Float(item.price){
            let cartItem = CartItem(menuItem: item, quantity: 1, consumed_amount:itemPrice)
            if let index = cart.firstIndex(where: { $0.menuItem.assign_id == item.assign_id }) {
                cart[index].quantity += 1
                cart[index].consumed_amount += itemPrice
            } else {
                cart.append(cartItem)
            }
        }
        
    }

}
