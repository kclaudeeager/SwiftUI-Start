//
//  cartItemUpdateView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/27/23.
//

import Foundation

import SwiftUI
struct CartItemUpdateView: View {
    var orderItem: OrderItem
    @State private var orderItemCopy: OrderItem?
    @StateObject var orderViewModel: OrderViewModel
    @Binding var orderItems:[OrderItem]
    @State private var itemDetails: (item: String, amount: Double, unit_name: String)?
    var isDelivered: Binding<Bool> {
        Binding<Bool>(
            get: {
                orderItemCopy?.status == "delivered"
            },
            set: {
                if var orderItemCopy = orderItemCopy {
                    orderItemCopy.status = $0 ? "delivered" : "pending"
                    self.orderItemCopy = orderItemCopy
                }
            }
        )
    }
    var body: some View {
       
        VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn:isDelivered) {
                Text("Delivered?")
            }.multilineTextAlignment(.leading)
            
            if let itemDetails = itemDetails {
                HStack(spacing: 8) {
                    Text(itemDetails.item)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Spacer()
                    if let orderItemCopy = orderItemCopy{
                        Text(String(format: "%.1f RWF", itemDetails.amount * Double(orderItemCopy.quantity)))
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(1)
                    }
                   

                }
            }
            HStack(spacing: 8) {
                if let orderItemCopy = orderItemCopy{
                    Text("Qty: \(orderItemCopy.quantity)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Button(action: {
                    if let orderItemCopy = orderItemCopy, orderItemCopy.quantity > 1 {
                        var updatedorderItemCopy = orderItemCopy
                        updatedorderItemCopy.quantity -= 1
                        self.orderItemCopy = updatedorderItemCopy
                        
                    }
                    else if let orderItemCopy = orderItemCopy, orderItemCopy.quantity == 1 {
                        let alert = UIAlertController(title: "Remove Item", message: "Are you sure you want to remove this item from your order?", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        
                        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in

                            self.orderItems.removeAll(where: { $0.id==orderItemCopy.id })
                            
                        }))
                        
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let rootViewController = windowScene.windows.first?.rootViewController else {
                            return
                        }
                        
                        rootViewController.present(alert, animated: true, completion: nil)
                    }
                    
                }, label: {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                }).buttonStyle(BorderlessButtonStyle())
                Button(action: {
                    if var orderItemCopy = orderItemCopy{
                        orderItemCopy.quantity += 1
                        self.orderItemCopy = orderItemCopy
                    }

                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.green)
                }).buttonStyle(BorderlessButtonStyle())
                Button(action: {
                    if let orderItemCopy = orderItemCopy{
                        let alert = UIAlertController(title: "Remove Item", message: "Are you sure you want to remove this item from your order?", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        
                        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
                            self.orderItems.removeAll(where: { $0.id==orderItemCopy.id })
                        }))
                        
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let rootViewController = windowScene.windows.first?.rootViewController else {
                            return
                        }
                        
                        rootViewController.present(alert, animated: true, completion: nil)
                    }
                }, label: {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.black)
                }).buttonStyle(BorderlessButtonStyle())
            }

        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .onAppear {
            orderViewModel.fetchItemPrice(assign_id: orderItem.assign_id) { result in
                switch result {
                case .success(let itemDetails):
                    self.itemDetails = itemDetails
                case .failure(let error):
                    print(error)
                }
            }
            self.orderItemCopy=orderItem
        }
        .onChange(of:self.orderItemCopy){
            updatedorderItemCopy in
                       guard let updatedorderItemCopy = updatedorderItemCopy else { return }
                       
            if let index = orderItems.firstIndex(where: { $0.id == updatedorderItemCopy.id }) {
                orderItems[index] = updatedorderItemCopy
                       }

        }
    }
}
