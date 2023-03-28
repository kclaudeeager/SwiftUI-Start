//
//  OrderView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/28/23.


import Foundation
import SwiftUI
struct OrderView: View {
     @State private var tableNumber: String
     @State private var showAddItemSheet = false
     let order: Order
     let onUpdate: () -> Void
     let onDelete: () -> Void
     let orderViewModel:OrderViewModel
     @Binding var cart: [CartItem]
     @Binding var showAlert: Bool
     let menuItems: [MenuItem]
     @State private var selectedTableNumber: String?

    public init(tableNumber: String, order: Order, onUpdate: @escaping () -> Void, onDelete: @escaping () -> Void, orderViewModel: OrderViewModel, cart: Binding<[CartItem]>, showAlert: Binding<Bool>, menuItems: [MenuItem]) {
        self._tableNumber = State(initialValue: tableNumber)
        self.order = order
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        self.orderViewModel = orderViewModel
        self._cart = cart
        self._showAlert = showAlert
        self.menuItems = menuItems
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(order.orderItems) { orderItem in
                CartItemUpdateView(orderItem: orderItem, orderViewModel: orderViewModel)
            }
            HStack {
                Spacer()
                Text(String(format: "Total: %.1f RWF", order.totalAmount))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
            HStack {
                Spacer()
                TextField("Table Number", text: $tableNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.subheadline)
                    .padding(.horizontal)
            }
            HStack {
                Spacer()
                Text("Server: \(order.serverId)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            HStack {
                Spacer()
                Text("Status: \(order.status)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            HStack {
                Spacer()
                Text("Created at: \(order.createdAt)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            HStack {
                Spacer()
                Text("Updated at: \(order.updatedAt)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            HStack {
                Spacer()
                Button(action: {
                    onUpdate()
//                    orderViewModel.updateOrderTable(orderId: order.id, tableNumber: tableNumber)
                }, label: {
                    Text("Update")
                })
                Button(action: onDelete, label: {
                    Text("Delete")
                })
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .toolbar {
            Button(action: {
                showAddItemSheet = true
            }) {
                Label("Add Item", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showAddItemSheet) {
            AddItemToOrderView(menuItems: menuItems, cart: $cart, selectedTableNumber: $selectedTableNumber, showAlert: $showAlert, onDismiss: {
                    print("Done")
                        })


        }
    }
    func addItemToCart(item: CartItem) {
        cart.append(item)
    }

}

struct OrderView_Previews: PreviewProvider {
    static var accompaniments: [Accompaniment] = [
        Accompaniment()
    ]
    @State static var showAlert: Bool=false
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
    static var menuItems:[MenuItem]=[MenuItem(
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
    ),MenuItem(
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
    )]
    
    static var previews: some View {
        let order = Order(id: 1, tableNumber: "Table 1", serverId: 123, status: "Pending", totalAmount: 3000, createdAt: "2022-03-24 12:00:00", updatedAt: "2022-03-24 14:00:00", orderItems: [OrderItem(id: 1,orderId:1, quantity:2,price:2000),OrderItem(id: 2,orderId:1, quantity:3,price:4000)])
        return NavigationView { OrderView(tableNumber:"B1", order: order, onUpdate: {}, onDelete: {},orderViewModel: OrderViewModel(),cart:$cartItems,showAlert:$showAlert,menuItems:menuItems)
        }
    }
}
