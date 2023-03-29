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
    let order:Order
    @State private var numberOfItems=0
    @Binding var cart: [CartItem]{
        didSet{
            print(cart)
            numberOfItems=cart.count
        }
    }
    @Binding var selectedTableNumber: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Text("Add Item to Order \(order.id)")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 16)
            
            if let tableNumber = selectedTableNumber {
                Text("Table: \(tableNumber)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
            }
            
            MenuGrid(menuList: menuItems, cart: $cart,handleMenuItemClicked: addItemToCart)
            
            Spacer()
            
            HStack {
                Button(action: {
                
                    DispatchQueue.main.async {
                        onDismiss()
                    }
                }, label: {
                    Text("Cancel")
                })
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 8))
                
                Spacer()
                if numberOfItems==0{
                    EmptyView()
                   
                }
                else{
                    Button(action: {
                        onDismiss()
                    }, label: {
                        Text("Add \(cart.count) items")
                            .foregroundColor(.white)
                    })
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 16, trailing: 16))
                    .background(Color.green)
                    .cornerRadius(8)
                }
            }
        }
        .background(Color(UIColor.systemBackground))
    }
    
    private func addItemToCart(item: MenuItem) {
        if let itemPrice = Float(item.price) {
            let cartItem = CartItem(menuItem: item, quantity: 1, consumed_amount: itemPrice)
            if let index = cart.firstIndex(where: { $0.menuItem.assign_id == item.assign_id }) {
                DispatchQueue.main.async {
                    cart.remove(at: index)
                }
            } else {
                DispatchQueue.main.async {
                    cart.append(cartItem)
                }
            }
        }
    }


}
