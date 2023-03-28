//
//  cartItemUpdateView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/27/23.
//

import Foundation

import SwiftUI
struct CartItemUpdateView: View {
    let orderItem: OrderItem
    @StateObject var orderViewModel: OrderViewModel
    
    @State private var itemDetails: (item: String, amount: Double, unit_name: String)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let itemDetails = itemDetails {
                HStack(spacing: 8) {
                    Text(itemDetails.item)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Spacer()
                    Text(String(format: "%.1f RWF", itemDetails.amount * Double(orderItem.quantity)))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)

                }
            }
            HStack(spacing: 8) {
                Text("Qty: \(orderItem.quantity)")
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
                Button(action: {
              
                            let alert = UIAlertController(title: "Remove Item", message: "Are you sure you want to remove this item from your order?", preferredStyle: .alert)

                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

                            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
                                
                            }))

                            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                  let rootViewController = windowScene.windows.first?.rootViewController else {
                                      return
                                  }

                            rootViewController.present(alert, animated: true, completion: nil)
                        
                }, label: {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.black)
                })
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
        }
    }
}
