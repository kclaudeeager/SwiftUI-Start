//
//  CartItemView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/26/23.
//

import Foundation

import SwiftUI

struct CartItemView: View {
    @Binding var cartItem: CartItem
    @Binding var cartItems:[CartItem]
    let accompaniments: [Accompaniment]
    let sauces: [Sauce]

    @State private var temperatureSelection = 0
    @State private var showOptions = false
    @State private var cartItemCopy: CartItem?
    @State private var accompanimentSelection = 0 {
        didSet {
            cartItemCopy?.accompaniment = accompaniments[accompanimentSelection]
        }
    }

    @State private var sauceSelection = 0 {
        didSet {
            cartItemCopy?.sauce = sauces[sauceSelection]
        }
    }
    private var temperatureSelectionString: String {
        switch temperatureSelection {
        case 0:
            return "Medium"
        case 1:
            return "Cold"
        case 2:
            return "Hot"
        default:
            return ""
        }
    }

    var combinedComment: String {
        return "\(temperatureSelectionString) - \(comment)"
    }

    @State private var comment: String = "" {
        didSet {
            updateCartItemComment()
        }
    }

    private func updateCartItemComment() {
     

        if var cartItemCopy=cartItemCopy{
            cartItemCopy.comment = combinedComment
            if let index = cartItems.firstIndex(where: { $0.menuItem.assign_id == cartItemCopy.menuItem.assign_id }) {
                cartItems[index] = cartItemCopy
            }
          
        }
 
    }


    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 8.0, x: 0, y: 2)
            VStack(alignment: .center, spacing: 8) {
                // Product info
                productInfoView()
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                // Quantity controls
                quantityControlsView()
                    .padding(EdgeInsets(top:8, leading:16 , bottom:8, trailing:16))
                
                // Additional comments and options
                if showOptions {
                    optionsView()
    
                        .padding(EdgeInsets(top:8, leading:16 , bottom:8, trailing:16))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .onChange(of: cartItemCopy) { updatedCartItemCopy in
                    guard let updatedCartItemCopy = updatedCartItemCopy else { return }
                     updateCartItemComment()
                    if let index = cartItems.firstIndex(where: { $0.menuItem.assign_id == updatedCartItemCopy.menuItem.assign_id }) {
                        cartItems[index] = updatedCartItemCopy
                    }
                }
    }
    
    @ViewBuilder
    private func productInfoView() -> some View {
        HStack(alignment: .top, spacing: 8) {
            if let cartItemCopy = cartItemCopy {
                Text(cartItemCopy.menuItem.unit_name == "" ? "\(cartItemCopy.menuItem.catg_name)" : "\(cartItemCopy.menuItem.catg_name) _ \(cartItemCopy.menuItem.unit_name)")
                    .font(.system(size: 12,weight: .medium))
                    .foregroundColor(Color.black)
                    .lineLimit(3)
                    .padding(.top, 4)
                    .multilineTextAlignment(.center)
                
                
                
                Spacer()
                
                Text(String(format: "%.1f RWF", cartItemCopy.consumed_amount))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)
                
                Text(":\(cartItemCopy.quantity)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)
            }
        }
    }
    
    @ViewBuilder
    private func quantityControlsView() -> some View {
        HStack(spacing: 16) {
            Button(action: {
                     if let cartItemCopy = cartItemCopy, cartItemCopy.quantity > 1 {
                         var updatedCartItemCopy = cartItemCopy
                         updatedCartItemCopy.quantity -= 1
                         updatedCartItemCopy.consumed_amount -= Float(updatedCartItemCopy.menuItem.price) ?? 0
                         self.cartItemCopy = updatedCartItemCopy
                     }
                     else if let cartItemCopy = cartItemCopy, cartItemCopy.quantity == 1 {
                         let alert = UIAlertController(title: "Remove Item", message: "Are you sure you want to remove this item from your cart?", preferredStyle: .alert)
                         
                         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                         
                         alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
                             self.cartItems.removeAll(where: { $0.menuItem.assign_id == cartItemCopy.menuItem.assign_id })
                         }))
                         
                         guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootViewController = windowScene.windows.first?.rootViewController else {
                             return
                         }
                         
                         rootViewController.present(alert, animated: true, completion: nil)
                     }
                 }, label: {
                     Image(systemName: "minus.circle")
                         .foregroundColor(cartItemCopy?.quantity ?? 0 > 1 ? .gray : .red)
                 })
                 

                 
            Button(action: {
                if var cartItemCopy = cartItemCopy {
                    cartItemCopy.quantity += 1
                    if let price = Float(cartItemCopy.menuItem.price) {
                        cartItemCopy.consumed_amount += price
                    } else {
                        cartItemCopy.consumed_amount += 0
                    }
                    self.cartItemCopy = cartItemCopy
                }

            }, label: {
                Image(systemName: "plus.circle")
                    .foregroundColor(.green)
            })

            Button(action: {
                if let cartItemCopy = cartItemCopy {
                  
                        let alert = UIAlertController(title: "Remove Item", message: "Are you sure you want to remove this item from your cart?", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

                        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
                            self.cartItems.removeAll(where: { $0.menuItem.assign_id == cartItemCopy.menuItem.assign_id })
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
            })

            Button(action: {
                showOptions.toggle()
            }, label: {
                if showOptions {
                    Image(systemName: "chevron.up")
                        .foregroundColor(.black)
                } else {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                }
            })
        }
        .onAppear {
          
                self.cartItemCopy = self.cartItem
                
        }
       
    }

    
    @ViewBuilder
    private func optionsView() -> some View {
        Group {
            Text("Additional Comments")
                .font(.system(size: 11, weight: .bold))
            
            // Temperature selection
           
                if cartItem.menuItem.dep_id == "2" {
                    temperatureSelectionView()
                }
                
                // Sauce picker Accompaniment picker
                if cartItem.menuItem.dep_id == "3" {
                    if(accompaniments.count>0){
                        accompanimentPickerView()
                    }
                    
                    if(sauces.count>0){
                        saucePickerView()
                    }
                    
                    
                }
                
                TextField("Type your comment here", text: $comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .id("comment") // Add an ID to the Picker
                    .onChange(of: comment) { _ in
                        // Trigger a change in cartItemCopy
                       updateCartItemComment()
                    }
            
            }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(10)
        }
    
    
    @ViewBuilder
    private func temperatureSelectionView() -> some View {
        Group{
            Text("States")
                .font(.system(size: 10, weight: .bold))
            HStack(spacing: 8) {
                RadioButton(title:"Medium", isSelected: temperatureSelection == 0) {
                    temperatureSelection = 0
                }
                RadioButton(title:"Cold", isSelected: temperatureSelection == 1) {
                    temperatureSelection = 1
                }
                RadioButton(title:"Hot", isSelected: temperatureSelection == 2) {
                    temperatureSelection = 2
                }
                
            }
        }
    }
    @ViewBuilder
    private func accompanimentPickerView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Accompaniment")
                .font(.system(size: 14, weight: .bold))
            
            Picker(selection: $accompanimentSelection, label: Text("Accompaniment")) {
                ForEach(Array(0..<accompaniments.count), id: \.self) { index in
                    Text(accompaniments[index].name)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .id("accompanimentPicker") // Add an ID to the Picker
            .onChange(of: accompanimentSelection) { _ in
                // Trigger a change in cartItemCopy
            
                if var cartItemCopy=cartItemCopy{
                    cartItemCopy.accompaniment=accompaniments[accompanimentSelection]
                    
                    if let index = cartItems.firstIndex(where: { $0.menuItem.assign_id == cartItemCopy.menuItem.assign_id }) {
                        cartItems[index] = cartItemCopy
                    }
                  

                }

            }
           
        }
    }

    
    func saucePickerView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sauce")
                .font(.system(size: 14, weight: .bold))
            
            Picker(selection: $sauceSelection, label: Text("Sauce")) {
                ForEach(sauces, id: \.self) { sauce in
                    Text(sauce.name)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .id("saucePicker") // Add an ID to the Picker
            .onChange(of: sauceSelection) { _ in
                // Trigger a change in cartItemCopy
            
                cartItemCopy?.sauce=sauces[sauceSelection]
                if var cartItemCopy=cartItemCopy{
                    cartItemCopy.sauce=sauces[sauceSelection]
                   
                    if let index = cartItems.firstIndex(where: { $0.menuItem.assign_id == cartItemCopy.menuItem.assign_id }) {
                        cartItems[index] = cartItemCopy
                    }
                  

                }
                //print(cartItemCopy!)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    struct RadioButton: View {
        let title: String
        var isSelected: Bool
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    Text(title)
                }
            }
        }
    }
    
    struct CartView_Previews: PreviewProvider {
        
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
                CartItemView(cartItem: $cartItem, cartItems:$cartItems, accompaniments: accompaniments, sauces: sauces)
            }

        
    }
}
