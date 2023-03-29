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
    @ObservedObject var orderViewModel:OrderViewModel
    let menuItems:[MenuItem]
    let user:User
 
    let sauces:[Sauce]
    let accompaniments:[Accompaniment]

    var body: some View {
        VStack{
            Text("Select the table").multilineTextAlignment(.center).padding()
            Spacer()
            List(tables) { table in
             
                   
                NavigationLink(destination: OrdersListView(
                    orders: table.orders,
                    tableOrders:table,orderViewModel: orderViewModel,
                    menusItems:menuItems,user: user,sauces: sauces,accompaniments: accompaniments
                )) {
                    Button(action: { }) {
                        Text(table.id).multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
}


struct TableView_Previews: PreviewProvider {
    static var order1 = Order(id: "1", tableNumber: "Table 1", serverId: 123, status: "Pending", totalAmount: "3000", createdAt: "2022-03-24 12:00:00", updatedAt: "2022-03-24 14:00:00", orderItems: [OrderItem(id: 1,orderId:1, quantity:2,price:2000, table_number:"B7"),OrderItem(id: 2,orderId:1, quantity:3,price:4000, table_number: "L1")])
    
    static var accompaniments: [Accompaniment] = [
        Accompaniment()
    ]
    static var sauces: [Sauce]=[Sauce()]
    @State static var  cartItems: [CartItem] = [
        CartItem(
            menuItem: MenuItem(
                assign_id: "1",
                item: "Cheeseburger",
                catg_id: "1",
                unit_id: "1",
                image: "burger",
                site_id: "1",
                dep_id: "1",
                has_parent: "0",
                piece_no: "0",
                orderable: "1",
                type: "1",
                status: "1",
                catg_name: "Burgers",
                item_id: "1",
                item_name: "Cheeseburger",
                class_item: "1",
                reg_date: "2022-03-22 09:10:15",
                delete_flag: "0",
                unit_name: "piece",
                price: "8.99"
            ),
            quantity: 1,
            consumed_amount: 0.0,
            accompaniment: accompaniments[0],
            sauce: sauces[0],
            comment: ""
        )
    ]
    @State static var cartItem:CartItem=CartItem(
        menuItem: MenuItem(
            assign_id: "1",
            item: "",
            catg_id: "",
            unit_id: "",
            image: "",
            site_id: "",
            dep_id: "3",
            has_parent: "",
            piece_no: "",
            orderable: "",
            type: "",
            status: "",
            catg_name: "Umuneke",
            item_id: "24",
            item_name: "",
            class_item: "",
            reg_date: "",
            delete_flag: "",
            unit_name: "",
            price: ""
        ),
        quantity: 1,
        consumed_amount: 0.0,
        accompaniment: accompaniments[0],
        sauce:sauces[0],
        comment: "No salt please"
    )
    static var previews: some View {
        let tables: [TabelOrder] = [
            TabelOrder(number: "Table 1", orders: [Order(id: "1", tableNumber: "Table 1", serverId: 123, status: "Pending", totalAmount: "3000", createdAt: "2022-03-24 12:00:00", updatedAt: "2022-03-24 14:00:00", orderItems: [OrderItem(id: 1, orderId: 1, quantity: 2, price: 2000, table_number: "B8"), OrderItem(id: 2, orderId: 1, quantity: 3, price: 4000, table_number: "L1" )])])
        ]
    
        let accompaniments: [Accompaniment] = [
            Accompaniment()
        ]
        let sauces: [Sauce]=[Sauce()]
        
        return TableView(tables: tables,orderViewModel: OrderViewModel(),menuItems: [],user: User(acc_id: "123", l_name: "Doe", f_name: "John", email: "johndoe@example.com", role_id: "1", co_id: "456", site_id: "789", dep_id: "2", mobile: "1234567890"), sauces: sauces,accompaniments: accompaniments)
    }
}

