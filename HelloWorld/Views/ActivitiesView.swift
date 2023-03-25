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
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 240/255, green: 238/255, blue: 238/255, alpha: 1.0))
                .ignoresSafeArea()
            VStack(spacing: 30) {
//                CustomAppBar(company:companyData)
               
                TabView {
                    MenusView(viewModel: MenuViewModel(),userData: userData,companyData: companyData)
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Menus")
                        }
                    DashboardView()
                        .tabItem {
                            Image(systemName: "chart.bar.xaxis")
                            Text("Dashboard")
                        }
                    OrdersView()
                        .tabItem {
                            Image(systemName: "square.and.pencil")
                            Text("Orders")
                        }
                }
            }
            .customTheme() // apply custom theme to the view hierarchy
        }.edgesIgnoringSafeArea(.all)
    }
}


struct ActivitiesView_Previews: PreviewProvider {

    static var previews: some View {
        ActivitiesView(userData: User(acc_id: "123", l_name: "Doe", f_name: "John", email: "johndoe@example.com", role_id: "1", co_id: "456", site_id: "789", dep_id: "2", mobile: "1234567890"), companyData: Company(cpy_ID: "456", cmp_sn: "Example Company", cmp_full: nil, phone: "123-456-7890", address: "123 Example St, City, State"))
    }
}

