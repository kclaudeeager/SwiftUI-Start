//
//  OrderView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/28/23.


import Foundation
import SwiftUI
struct OrderView: View {
    let tableNumber: String
    @State private var showAddItemSheet = false
    @Binding var order: Order
    let orderViewModel: OrderViewModel
    @State private var cart: [CartItem]=[]
    let menuItems: [MenuItem]
    let user: User
    let accompaniments: [Accompaniment]
    let sauces: [Sauce]
    @State private var showSaveButton=false
    @State private var selectedTableNumber: String=""
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Order: \(order.id)")
                    .font(.title).multilineTextAlignment(.center)
                Spacer()
                Button(action: {
                    showAddItemSheet = true
                }) {
                    HStack {
                        Text("Add Item")
                        Label("", systemImage: "plus")
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                }
                .buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: $showAddItemSheet) {
                    AddItemToOrderView(menuItems: menuItems, order: order, cart: $cart, selectedTableNumber: $selectedTableNumber, onDismiss: {
                        showAddItemSheet=false
                        
                    })
                }
            }
            .padding(.bottom,5)
            
            ForEach(order.orderItems,id: \.id) { orderItem in
                CartItemUpdateView(orderItem: orderItem, orderViewModel: orderViewModel,orderItems:$order.orderItems)
            }
            if !showAddItemSheet && cart.count>0{
                
                Text("New items").font(.subheadline)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 8) {
                        ForEach(cart.indices, id: \.self) { index in
                            CartItemView(cartItem: $cart[index], cartItems: $cart, accompaniments: accompaniments, sauces: sauces)
                        }
                    }
                    .padding(5)
                }.onAppear(){
                    
                    if cart.count > 0{
                        showSaveButton=true
                        
                        
                    }
                    
                    
                }
            }
            HStack {
                Spacer()
                if let totalAmount=Double(order.totalAmount){
                    Text(String(format: "Total: %.1f RWF", totalAmount))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                }
            }
            
            HStack {
                Spacer()
                Text("Table Number: \(order.tableNumber)")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.subheadline)
                    .padding(.horizontal)
            }
            .multilineTextAlignment(.center)
            
            HStack {
                Spacer()
                Text("Server: \(user.f_name)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .multilineTextAlignment(.center)
            
            HStack {
                Spacer()
                Text("Status: \(order.status)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .multilineTextAlignment(.center)
            
            HStack {
                Spacer()
                Text("Created at: \(order.createdAt)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .multilineTextAlignment(.center)
            
            HStack {
                Spacer()
                Text("Updated at: \(order.updatedAt)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .multilineTextAlignment(.center)
            
            HStack {
                Spacer()
                if self.showSaveButton{
                    Button(action: {
                        DispatchQueue.main.async {
                            
                        }
                    }, label: {
                        Text("Save changes")
                    }) .buttonStyle(BorderlessButtonStyle())
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                else{
                    EmptyView()
                }
                
                
                
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .onAppear(){
            self.selectedTableNumber=order.tableNumber
        }
        .onChange(of: order){
            updatedOrder in
            self.showSaveButton=true
            order.totalAmount=String(calculateOrderTotal())
        }
        
    }
    func calculateOrderTotal() -> Double {
        let orderItems:[OrderItem]=order.orderItems

        let totalOrderAmount = Double(orderItems.reduce(0.0) { $0 + $1.price * Double($1.quantity) })
        return totalOrderAmount
        
    }
    func createOrder(orderId:String) {

            let url = URL(string: Urls.generateInvoice)!
                let orderItemsJsonArray = cart.map { cartItem -> [String: Any] in
                    return [
                        "assign_id": cartItem.menuItem.assign_id,
                        "quantity": cartItem.quantity,
                        "price": cartItem.menuItem.price,
                        "dep_id": cartItem.menuItem.dep_id,
                        "accomp": cartItem.accompaniment?.name ?? "",
                        "sauce": cartItem.sauce?.name ?? "",
                        "comment": cartItem.comment ?? ""
                    ]
                }
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
     @State var order = Order(id: "1", tableNumber: "Table 1", serverId: 123, status: "Pending", totalAmount: "3000", createdAt: "2022-03-24 12:00:00", updatedAt: "2022-03-24 14:00:00", orderItems: [OrderItem(id: 1,orderId:1, quantity:2,price:2000, table_number: "B9"),OrderItem(id: 2,orderId:1, quantity:3,price:4000, table_number:"L9")])
        let accompaniments: [Accompaniment] = [
            Accompaniment()
        ]
        let sauces: [Sauce]=[Sauce()]
        return  OrderView(tableNumber:"B1", order: $order,orderViewModel: OrderViewModel(),menuItems:menuItems,user:  User(acc_id: "123", l_name: "Doe", f_name: "John", email: "johndoe@example.com", role_id: "1", co_id: "456", site_id: "789", dep_id: "2", mobile: "1234567890"),accompaniments: accompaniments,sauces: sauces)
        
    }
}
