//
//  ActivitiesView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/10/23.
//

import SwiftUI
struct ActivitiesView: View {
    let userData: User
    let companyData: Company
    var menuViewModel: MenuViewModel
    @ObservedObject var orderViewModel: OrderViewModel
    @State private var tableOrders : [TabelOrder] = []
    @State private var showAlert = false

    var body: some View {
        ZStack {
            Color(UIColor(red: 240/255, green: 238/255, blue: 238/255, alpha: 1.0))
                .ignoresSafeArea()
            VStack(spacing: 30) {
                TabView {
                    MenusView(viewModel: menuViewModel, userData: userData, companyData: companyData)
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Menus")
                        }
                    DashboardView()
                        .tabItem {
                            Image(systemName: "chart.bar.xaxis")
                            Text("Dashboard")
                        }
                    
                    OrdersView(tables: tableOrders,orderViewModel: orderViewModel,menuViewModel: menuViewModel,user: userData)
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                        Text("Orders")
                    }
                }
              
                .customTheme()
            }
            .onAppear {
                menuViewModel.user = userData
                if let serverId = Int(userData.acc_id) {
                    orderViewModel.fetchOrders(serverId: serverId) {
                        tableOrders = orderViewModel.tableOrders ?? []
                    }
                } else {
                    print("Unable to convert it to int")
                }
               
               
            }
            .customTheme()
        }
        .edgesIgnoringSafeArea(.all)
       
            
        
    }
}



struct ActivitiesView_Previews: PreviewProvider {

    static var previews: some View {
        ActivitiesView(userData: User(acc_id: "123", l_name: "Doe", f_name: "John", email: "johndoe@example.com", role_id: "1", co_id: "456", site_id: "789", dep_id: "2", mobile: "1234567890"), companyData: Company(cpy_ID: "456", cmp_sn: "Example Company", cmp_full: nil, phone: "123-456-7890", address: "123 Example St, City, State"),menuViewModel: MenuViewModel(),orderViewModel:OrderViewModel())
    }
}

