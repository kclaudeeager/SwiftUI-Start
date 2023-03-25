//
//  CategoryList.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
import SwiftUI
struct CategoryPicker: View {
    @Binding var categories: [Category]
    @Binding var selectedCategory: Category
    var onCategorySelected: ((Category) -> Void)?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        self.selectedCategory = category
                        self.onCategorySelected?(category)
                    }) {
                        Text(category.itemName)
                            .font(.headline)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(selectedCategory == category ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}



