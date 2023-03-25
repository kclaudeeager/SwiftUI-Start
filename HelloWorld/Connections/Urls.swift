//
//  Urls.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation

class Urls {
    static let startUrl="https://uncle.itec.rw"
    static let baseUrl = "\(startUrl)/RestaurantApi/management.php/"
    static var fetchOrders = "\(baseUrl)orders?server_id="
    static var generateInvoice = "\(baseUrl)orders/"
    static var getMenuItems = "\(baseUrl)menu_items/"
    static var getCategories = "\(baseUrl)categories/"
    static var getChildrenMenus = "\(baseUrl)menu_children/"
    static var getCategoryById = "\(baseUrl)categories?id="
    static var updateOrder = "\(baseUrl)orders?id="
    static let login = "\(baseUrl)login"
    static let tables = "\(baseUrl)tables?site_id="
}
