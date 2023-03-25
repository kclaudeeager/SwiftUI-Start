//
//  MenuGrid.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation
import SwiftUI
struct MenuGrid: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let menuList: [MenuItem]
    
    var body: some View {
        GeometryReader { geometry in
            let columns = getColumnCount(geometry: geometry)
            let cardWidth = getCardWidth(geometry: geometry, columnCount: columns)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(menuList) { item in
                        MenuItemView(item: item)
                            .frame(width: cardWidth, height: cardWidth * 1.5)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 50)
            }
        }
    }
    
    func getColumnCount(geometry: GeometryProxy) -> [GridItem] {
        switch horizontalSizeClass {
        case .compact:
            return [GridItem(.flexible()), GridItem(.flexible())]
        case .regular:
            if geometry.size.width < 800 {
                return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            } else {
                return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            }
        default:
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        }
    }
    
    func getCardWidth(geometry: GeometryProxy, columnCount: [GridItem]) -> CGFloat {
        let screenWidth = geometry.size.width
        let padding: CGFloat = 16
        let spacing: CGFloat = 16 * CGFloat(columnCount.count - 1)
        let totalWidth = screenWidth - padding * 2 - spacing
        return totalWidth / CGFloat(columnCount.count)
    }
}

struct MenuGrid_Previews: PreviewProvider {
    static var previews: some View {
        let menuItems = [
                MenuItem(assign_id: "1", item: "1", catg_id: "1", unit_id: "1", image: "\(Urls.startUrl)img/products/paradboxotot.png", site_id: "1", dep_id: "1", has_parent: nil, piece_no: nil, orderable: nil, type: "1", status: "1", catg_name: "Category 1", item_id: "1", item_name: "Item 1", class_item: "1", reg_date: "", delete_flag: "0", unit_name: "Unit 1", price: "10"),
                MenuItem(assign_id: "2", item: "2", catg_id: "2", unit_id: "2", image: "\(Urls.startUrl)img/products/paradboxotot.png", site_id: "1", dep_id: "1", has_parent: nil, piece_no: nil, orderable: nil, type: "1", status: "1", catg_name: "Category 2", item_id: "2", item_name: "Item 2", class_item: "1", reg_date: "", delete_flag: "0", unit_name: "Unit 2", price: "20"),
                MenuItem(assign_id: "3", item: "3", catg_id: "3", unit_id: "3", image: "\(Urls.startUrl)img/products/paradboxotot.png", site_id: "1", dep_id: "1", has_parent: nil, piece_no: nil, orderable: nil, type: "1", status: "1", catg_name: "Category 3", item_id: "3", item_name: "Item 3", class_item: "1", reg_date: "", delete_flag: "0", unit_name: "Unit 3", price: "30")
            ]
        
        MenuGrid(menuList: menuItems)
    }
}
