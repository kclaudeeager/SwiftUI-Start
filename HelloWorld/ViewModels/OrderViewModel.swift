//
//  OrderViewModel.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/28/23.
//

import Foundation

class OrderViewModel:ObservableObject{
    
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

}
