//
//  OrdersView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
import SwiftUI
struct OrdersView: View {
    let tables: [TabelOrder]
    let orderViewModel: OrderViewModel
    let menuViewModel:MenuViewModel
    
    @State private var accompaniments: [Accompaniment] = []
    @State private var sauces: [Sauce] = []
    let user: User
    @State private var menuItems: [MenuItem] = []
    var body: some View {
      
            Group {
                if menuItems.isEmpty {
                    // Display loading spinner or any other loading view
                    ProgressView("Loading...")
                }
                else {
                    // Display the table view
                    TableView(tables: tables, orderViewModel: orderViewModel, menuItems: menuItems, user: user,sauces: sauces,accompaniments: accompaniments)
                }
            }.onAppear {
                // Load the menu items asynchronously
                if menuViewModel.filteredMenuList.isEmpty{
                    menuViewModel.getMenuItems() {
                        print(menuViewModel.filteredMenuList)
                        self.menuItems = menuViewModel.filteredMenuList
                    }
                }
                else{
                    self.menuItems = menuViewModel.filteredMenuList
                    print(menuViewModel.filteredMenuList)
                }
                menuViewModel.fetchAccompanimentsAndSauces(siteId:user.site_id) { (response) in
                    guard let response = response else {
                        print("Failed to fetch accompaniments and sauces")
                        return
                    }
                    self.accompaniments = response.accompaniments
                    self.sauces = response.sauces
                    
                }
            }
            
        }
        
       
    

}

