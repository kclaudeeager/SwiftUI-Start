//
//  CheckoutView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/26/23.
//

import Foundation
import SwiftUI



struct CheckoutView: View {
    @Binding var cartItems: [CartItem]
    let accompaniments: [Accompaniment]
    let sauces: [Sauce]
    let serviceTables: [ServiceTable]
    let orderResponse:String
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var tableSelection = 0
    @State private var filteredTables: [ServiceTable] = []
    @State private var isTableSelected = false
    @State private var selectedTable: ServiceTable?
    @State private var showTablePicker = true
    @State private var showError = false
    let isUploading:Bool
    let createOrder: (String) -> Void
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 16) {
                    ForEach(cartItems.indices, id: \.self) { index in
                        CartItemView(cartItem: $cartItems[index], cartItems: $cartItems, accompaniments: accompaniments, sauces: sauces)
                    }
                }
                .padding(16)
            }
            
            if showTablePicker {
                tablePickerView()
            } else if let selectedTable = selectedTable {
                VStack {
                    Divider()
                    Text("Selected Table: \(selectedTable.number)")
                        .padding(.vertical, 8)
                        .onTapGesture {
                            showTablePicker = true
                        }
                    Divider()
                    // Render the rest of the view here
                }
            }
            
            HStack {
                Text(String(format: "Total: %.1f RWF", calculateOrderTotal()))
                    .font(.headline)
                    .padding(.leading, 16)
                Spacer()
                Button(action: {
                    if let selectedTable=selectedTable{
                        createOrder(selectedTable.number)
                    }
                    else{
                        showError = true
                    }
                  
                }, label: {
                    Text("Submit Order")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                })
                .padding(.trailing, 16)
            }
            .padding(.bottom, 16)
        }
        .navigationTitle("Checkout")
        .overlay(isUploading ? ProgressView("Creating order...") : nil)
        if showError {
                        Text("Please select a table first")
                            .foregroundColor(.red)
                    }
        else{
            EmptyView()
             if orderResponse != "" {
                withAnimation(.easeInOut(duration: 0.5)) {
                    ToastMessageView(message: orderResponse)
                        .transition(.move(edge: .bottom))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            }
                        }
                }
            }
        }
    }
    
    
    func calculateOrderTotal() -> Double {
        return Double(cartItems.reduce(0.0) { $0 + $1.consumed_amount })
    }
    
    @ViewBuilder
    private func tablePickerView() -> some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $searchText)
                    .autocapitalization(.none)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)

            if isTableSelected {
                Divider()
                if let selectedTable=selectedTable{  Text("Selected Table: \(selectedTable.number)")
                        .padding(.vertical, 8)
                }
            } else if !filteredTables.isEmpty {
                Divider()
                
                List {
                    ForEach(filteredTables.indices, id: \.self) { index in
                        Button(action: {
                            selectedTable = filteredTables[index]
                            isTableSelected = true
                        }
                        ){
                            Text(filteredTables[index].number)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16).multilineTextAlignment(.center)
                        }
//                        .buttonStyle(PlainButtonStyle())
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(index % 2 == 0 ? Color.blue : Color.gray)
//                        .foregroundColor(.white)
                       
                    }
                }
                .listStyle(PlainListStyle())
              

            } else {
                Divider()
                Text("No tables found")
                    .foregroundColor(.secondary)
            }
        }
        .onChange(of: searchText) { query in
            withAnimation {
                filteredTables = serviceTables.filter { $0.number.lowercased().contains(query.lowercased()) }
                isSearching = !query.isEmpty
                isTableSelected = !isSearching
            }
        }
    }

}


