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
    
    var selectedCategoryBinding: Binding<Category?> {
        Binding<Category?>(
            get: {
                selectedCategory
            },
            set: {
                selectedCategory = $0
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchView()
            CategoryPicker(categories: $viewModel.categories, selectedCategory: Binding<Category>(
                get: { self.selectedCategory ?? self.viewModel.categories.first ?? Category(itemId: "", itemName: "", classItem: "", siteId: "", depId: "", regDate: "", status: "", deleteFlag: "") },
                set: { self.selectedCategory = $0 }
            ))




            Text("Select menu")
                .foregroundColor(.black)
                .font(.headline)
                .padding()
            if viewModel.filteredMenuList.isEmpty {
                Text("Loading...")
                    .padding()
            } else {
                MenuGrid(menuList: viewModel.filteredMenuList)
            }
            Spacer()
            CartButton()
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
    }
}


struct MenusView_Previews: PreviewProvider {
    static var previews: some View {
        MenusView(viewModel: MenuViewModel(),userData: User(acc_id: "123", l_name: "Doe", f_name: "John", email: "johndoe@example.com", role_id: "1", co_id: "456", site_id: "789", dep_id: "2", mobile: "1234567890"), companyData: Company(cpy_ID: "456", cmp_sn: "Example Company", cmp_full: nil, phone: "123-456-7890", address: "123 Example St, City, State"))
    }
}
