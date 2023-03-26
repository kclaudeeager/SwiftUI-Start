//
//  MenusView.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
import SwiftUI

struct MenusView: View {
    @ObservedObject var viewModel: MenuViewModel
    @State var selectedCategory: Category? = nil
    let userData: User
    let companyData: Company
    @State private var searchText = ""
    
    var body: some View {
        let handleMenuItemClicked: (MenuItem) -> Void = { menuItem in
            viewModel.handleMenuItemViewClicked(menuItem: menuItem)
        }
        
     VStack(spacing: 0) {
            SearchView(searchText: $searchText)
            CategoryPicker(categories: $viewModel.categories, selectedCategory: Binding<Category>(
                get: { self.selectedCategory ?? self.viewModel.categories.first ?? Category(itemId: "", itemName: "", classItem: "", siteId: "", depId: "", regDate: "", status: "", deleteFlag: "") },
                set: { self.selectedCategory = $0 }
            ))
            Text("Select menu")
                .foregroundColor(.black)
                .font(.headline)
                .padding()
            
            ScrollViewReader { scrollViewProxy in
                if viewModel.filteredMenuList.isEmpty {
                    Text("Loading...")
                        .padding()
                } else {
                    MenuGrid(menuList: viewModel.filteredMenuList, handleMenuItemClicked: handleMenuItemClicked)
                        .onChange(of: selectedCategory, perform: { _ in
                            scrollViewProxy.scrollTo(0, anchor: .top)
                        })
                        .onChange(of: searchText, perform: { _ in
                            scrollViewProxy.scrollTo(0, anchor: .top)
                        })
                }
            }
            
            Spacer()
            HStack {
                if viewModel.totalCartItems > 0 {
                    CartButton(totalCartItems: viewModel.totalCartItems,cart:viewModel.cart)
                } else {
                    EmptyView()
                }
            }
            .padding()
            
        }
        .onAppear {
            viewModel.getMenuItems()
            viewModel.getCategories(siteId: userData.site_id) { result in
                switch result {
                case .success(let categories):
                    if let firstCategory = categories.first {
                        self.selectedCategory = firstCategory
                    } else {
                        print("No categories found")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        .onChange(of: selectedCategory) { category in
            guard let category = category else { return }
            viewModel.filterMenuListByCategory(category)
        }
        .onChange(of: searchText) { query in
            viewModel.filterMenuListByQuery(query: query)
        }
        }
    
    
}

struct MenusView_Previews: PreviewProvider {
    static var previews: some View {
        MenusView(viewModel: MenuViewModel(),userData: User(acc_id: "123", l_name: "Doe", f_name: "John", email: "johndoe@example.com", role_id: "1", co_id: "456", site_id: "789", dep_id: "2", mobile: "1234567890"), companyData: Company(cpy_ID: "456", cmp_sn: "Example Company", cmp_full: nil, phone: "123-456-7890", address: "123 Example St, City, State"))
    }
}
