//
//  TableView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/28/23.
//

import Foundation
import SwiftUI
struct TableView: View {
    let tables: [TabelOrder]
    let onSelectTable: (TabelOrder) -> Void
    
    var body: some View {
        VStack{
            Text("Select the table").multilineTextAlignment(.center).padding()
            Spacer()
            List(tables) { table in
                Button(action: { onSelectTable(table) }) {
                    Text(table.id).multilineTextAlignment(.center)
                }
            }
        }
    }
}


struct TableView_Previews: PreviewProvider {
    static var order1 = Order(id: 1, tableNumber: "Table 1", serverId: 123, status: "Pending", totalAmount: 3000, createdAt: "2022-03-24 12:00:00", updatedAt: "2022-03-24 14:00:00", orderItems: [OrderItem(id: 1,orderId:1, quantity:2,price:2000),OrderItem(id: 2,orderId:1, quantity:3,price:4000)])
    static var previews: some View {
        let tables: [TabelOrder] = [
            TabelOrder(number: "Table 1", orders: [Order(id: 1, tableNumber: "Table 1", serverId: 123, status: "Pending", totalAmount: 3000, createdAt: "2022-03-24 12:00:00", updatedAt: "2022-03-24 14:00:00", orderItems: [OrderItem(id: 1, orderId: 1, quantity: 2, price: 2000), OrderItem(id: 2, orderId: 1, quantity: 3, price: 4000)]),order1]),
            
            TabelOrder(number: "Table 2", orders: [Order(id: 2, tableNumber: "Table 2", serverId: 456, status: "Completed", totalAmount: 5000, createdAt: "2022-03-25 10:00:00", updatedAt: "2022-03-25 12:00:00", orderItems: [OrderItem(id: 3, orderId: 2, quantity: 1, price: 2500)])]),
            TabelOrder(number: "Table 3", orders: [Order(id: 3, tableNumber: "Table 3", serverId: 789, status: "Pending", totalAmount: 1500, createdAt: "2022-03-26 15:00:00", updatedAt: "2022-03-26 16:00:00", orderItems: [OrderItem(id: 4, orderId: 3, quantity: 3, price: 500)])])
        ]
        
        return TableView(tables: tables) { selectedTable in
            print("Selected Table: \(selectedTable.id)")
        }
    }
}

