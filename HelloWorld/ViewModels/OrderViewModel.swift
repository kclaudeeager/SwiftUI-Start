//
//  OrderViewModel.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/28/23.
//

import Foundation

class OrderViewModel:ObservableObject{
    
    @Published var tableOrders:[TabelOrder]?
    
    @Published var totalCartItems = 0
    @Published private var totalConsumed = 0.0
    @Published var cart = [CartItem]() {
        didSet {
            totalCartItems = cart.count
//            print(cart)
            totalConsumed=calculateOrderTotal()
        }
    }
    func calculateOrderTotal() -> Double {
        return Double(cart.reduce(0.0) { $0 + $1.consumed_amount })
    }
    func fetchItemPrice(assign_id: Int, completion: @escaping (Result<(item: String, amount: Double, unit_name: String), Error>) -> Void) {
        let urlString = "\(Urls.orderItemDetails)\(assign_id)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            do {
                let response = try JSONDecoder().decode(ItemPriceResponse.self, from: data)
                completion(.success((item: response.item, amount: Double(response.amount) ?? 0, unit_name: response.unit_name)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
  
    func fetchOrders(serverId: Int, completion: @escaping () -> Void) {
        let url = "\(Urls.fetchOrders)\(serverId)"
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching orders: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                var tableList = [TabelOrder]()
                for table in json ?? [] {
                    let tableNumber = table["table_number"] as? String ?? ""
                    var orderList = [Order]()
                    if let orders = table["orders"] as? [[String:Any]] {
                        for order in orders {
                            
                            let id = order["id"] as? String ?? "0"
                            let status = order["status"] as? String ?? ""
                            let totalAmount = order["total_amount"] as? String ?? "0.0"
                           
                            let createdAt = order["created_at"] as? String ?? ""
                            let updatedAt = order["updated_at"] as? String ?? ""
                            let orderItemArray = order["order_items"] as? [[String:Any]] ?? []
                            var orderItems = [OrderItem]()
                            for orderItemJson in orderItemArray {
                                let orderId = orderItemJson["order_id"] as? Int ?? 0
                                let quantity = orderItemJson["quantity"] as? Int ?? 0
                                let price = orderItemJson["price"] as? Double ?? 0.0
                                let statusItem = orderItemJson["status"] as? String ?? ""
                                let id = orderItemJson["id"] as? Int ?? 0
                                let assignId = orderItemJson["assign_id"] as? Int ?? 0
                                let orderItem = OrderItem(id: id, assign_id: assignId, orderId: orderId, quantity: quantity, price: price, status: statusItem,table_number: tableNumber)
                                orderItems.append(orderItem)
                            }
                            let createdOrder = Order(id: id, tableNumber: tableNumber, serverId: serverId, status: status, totalAmount: totalAmount, createdAt: createdAt, updatedAt: updatedAt, orderItems: orderItems)
                          
                            orderList.append(createdOrder)
                        }
                    }
                  
                    let table = TabelOrder(number: tableNumber, orders: orderList)
                    tableList.append(table)
                }
               
              
                DispatchQueue.main.async {
                           self.tableOrders=tableList
                               completion()
                           }
            
            } catch let error {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }


        

}
