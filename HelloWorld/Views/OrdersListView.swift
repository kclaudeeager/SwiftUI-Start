//
//  OrdersListView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/28/23.
//

import Foundation
import SwiftUI
struct OrdersListView: View {
    @State var orders: [Order]
    let tableOrders:TabelOrder
    @ObservedObject var orderViewModel:OrderViewModel
    let menusItems:[MenuItem]
    let user:User
    let sauces:[Sauce]
    let accompaniments:[Accompaniment]
    
    var body: some View{
        VStack{
            Text("Orders for table: \(tableOrders.number)")
                .foregroundColor(.blue)
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            List(orders.indices, id: \.self) { index in
                let binding = Binding<Order>(
                    get: { self.orders[index] },
                    set: { self.orders[index] = $0 }
                )
                OrderView(
                    tableNumber: tableOrders.number,
                    order: binding,
                    orderViewModel: orderViewModel,
                    menuItems: menusItems,
                    user: user,
                    accompaniments: accompaniments,
                    sauces: sauces
                )
                .listStyle(.plain)
            }
            .onAppear {
                UITableView.appearance().separatorStyle = .singleLine
            }
        }
    }
}

