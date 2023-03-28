//
//  MenuViewModel.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/25/23.
//

import Foundation

class MenuViewModel:ObservableObject {
//    init() {
//            getMenuItems()
//        }

    @Published var isUploading = false
    @Published var orderResponse=""
    @Published var totalCartItems = 0
    @Published var user:User?
    @Published private var totalConsumed = 0.0
    @Published var cart = [CartItem]() {
        didSet {
            totalCartItems = cart.count
//            print(cart)
            totalConsumed=calculateOrderTotal()
        }
    }

   
    @Published var categories = [Category]()
    @Published var filteredMenuList: [MenuItem] = []
  
    @Published var selectedMenuItems = LiveData<Set<MenuItem>>([])
    private var selectedTable: ServiceTable? = nil
    private var selectedAccompaniment: Accompaniment? = nil
    private var selectedSauce: Sauce? = nil
    private var comment: String? = nil

    private var categoryList = LiveData<[Category]>([])
    var categoryListObserver: (([Category]) -> Void)? {
        didSet {
            categoryList.observe { categories in
                self.categoryListObserver?(categories)
            }
        }
    }

    private var menuList = LiveData<[MenuItem]>([])
    var menuListObserver: (([MenuItem]) -> Void)? {
        didSet {
            menuList.observe { menuItems in
                self.menuListObserver?(menuItems)
                self.filteredMenuList = menuItems
            }
        }
    }
   
   

    private var selectedCategory = LiveData<Category>(Category())
    var selectedCategoryObserver: ((Category) -> Void)? {
        didSet {
            selectedCategory.observe { category in
                self.selectedCategoryObserver?(category)
                self.filterMenuListByCategory(category)
            }
        }
    }

    var serviceTables: [ServiceTable]? = nil

     func filterMenuListByCategory(_ category: Category) {
        let filteredMenuList = menuList.value.filter { $0.item_id == category.itemId }
        let otherMenuList = menuList.value.filter { $0.item_id != category.itemId }
        self.filteredMenuList = filteredMenuList + otherMenuList
     
    }

    func filterMenuListByQuery(query: String) {
 
        DispatchQueue.global(qos: .userInitiated).async {
            let filteredList = self.menuList.value
           
            let matchedList = filteredList.filter {
                $0.catg_name.localizedCaseInsensitiveContains(query) ||
                $0.item_name.localizedCaseInsensitiveContains(query)
            }
            let resultList = matchedList + filteredList.filter { !matchedList.contains($0) }
            self.setMenuList(menuList: resultList)
            
        }
     
       
    }
 
    func handleMenuItemViewClicked(menuItem: MenuItem) {
      
        if let index = self.cart.firstIndex(where: { $0.menuItem.assign_id == menuItem.assign_id }) {
            // menu item is already in the cart, so remove it
            self.cart.remove(at: index)
        } else {
            // menu item is not in the cart, so add it
    
            let price = menuItem.price
            if let priceValue = Float(price) {
                let cartItem = CartItem(menuItem: menuItem, quantity: 1, consumed_amount: priceValue, accompaniment: nil, sauce: nil, comment: nil)
                self.cart.append(cartItem)
              
            }
        }
     
    }


    
    func getMenuItems() {
        guard let url = URL(string: Urls.getMenuItems) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
              
                if let jsonData = jsonString.data(using: .utf8) {
                    
                    do {
                       
                        let jsonDecoder = JSONDecoder()
                        let menuList = try jsonDecoder.decode([MenuItem].self, from: jsonData)
                        
                        self.setMenuList(menuList: menuList)
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Error converting data to string")
            }

        }
        
        task.resume()
    }
    func fetchAccompanimentsAndSauces(siteId: String, callback: @escaping (AccompanimentSauceResponse?) -> Void) {
        guard let url = URL(string: "\(Urls.baseUrl)others?site_id=\(siteId)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                callback(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("Invalid response")
                callback(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned")
                callback(nil)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(AccompanimentSauceResponse.self, from: data)
                callback(response)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                callback(nil)
            }
        }
        
        task.resume()
    }

    func fetchTables(siteId: String, callback: @escaping ([ServiceTable]?) -> Void) {
        guard let url = URL(string: "\(Urls.tables)\(siteId)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                callback([])
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("Invalid response")
                callback([])
                return
            }
            
            guard let data = data else {
                print("No data returned")
                callback([])
                return
            }
            
           
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(TablesResponse.self, from: data)
                callback(response.tables)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                callback([])
            }
        }
        
        task.resume()
    }

    func getCategories(siteId: String, completion: @escaping (Result<[Category], Error>) -> Void) {
        guard let url = URL(string: "\(Urls.getCategories)?site_id=\(siteId)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("Invalid response")
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(.failure(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let categories = try jsonDecoder.decode([Category].self, from: data)
                DispatchQueue.main.async {
                    self.categories = categories
                }
                completion(.success(categories))
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    func getCategoryById(id: Int, completion: @escaping (Category?) -> Void) {
        let url = URL(string: "\(Urls.getCategoryById)\(id)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data returned")
                completion(nil)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dict = json as? [String: Any],
                      let itemId = dict["item_id"] as? String,
                      let itemName = dict["item_name"] as? String,
                      let classItem = dict["class_item"] as? String,
                      let siteId = dict["site_id"] as? String,
                      let depId = dict["dep_id"] as? String,
                      let regDate = dict["reg_date"] as? String,
                      let status = dict["status"] as? String,
                      let deleteFlag = dict["delete_flag"] as? String
                else {
                    print("Unable to parse JSON response")
                    completion(nil)
                    return
                }

                let category = Category(itemId: itemId, itemName: itemName, classItem: classItem, siteId: siteId, depId: depId, regDate: regDate, status: status, deleteFlag: deleteFlag)
                completion(category)

            } catch let error {
                print("Error decoding JSON response: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }



    private func setMenuList(menuList: [MenuItem]) {
        DispatchQueue.main.async {
            self.menuList.value = menuList
            self.filteredMenuList = menuList
        }
    }
    func calculateOrderTotal() -> Double {
        return Double(cart.reduce(0.0) { $0 + $1.consumed_amount })
    }
    
    func createOrder(tableNumber: String) {
        if let user=user{
            let url = URL(string: Urls.generateInvoice)!
                let orderItemsJsonArray = cart.map { cartItem -> [String: Any] in
                    return [
                        "assign_id": cartItem.menuItem.assign_id,
                        "quantity": cartItem.quantity,
                        "price": cartItem.menuItem.price,
                        "dep_id": cartItem.menuItem.dep_id,
                        "accomp": cartItem.accompaniment?.name ?? "",
                        "sauce": cartItem.sauce?.name ?? "",
                        "comment": cartItem.comment ?? ""
                    ]
                }
                let orderJsonObject: [String: Any] = [
                    "table_number": tableNumber,
                    "server_id": user.acc_id,
                    "site_id": user.site_id,
                    "total_amount": totalConsumed
                ]
                let fullOrderJsonObject: [String: Any] = [
                    "order": orderJsonObject,
                    "order_items": orderItemsJsonArray
                ]
                let jsonData = try! JSONSerialization.data(withJSONObject: fullOrderJsonObject)
                print("Json:: \(jsonData)")
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData

                isUploading = true // show progress UI

                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    DispatchQueue.main.async {
                        self.isUploading = false // hide progress UI
                    }
                    if let error = error {
                        print("Error creating order: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            // Show error message
                        }
                        return
                    }
                    guard let data = data else {
                        print("No data returned from server")
                        return
                    }
                    guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                          let response = responseJSON as? [String: Any],
                          let message = response["message"] as? String else {
                        print("Invalid response from server")
                        return
                    }
                   
                    DispatchQueue.main.async {
                        self.orderResponse=message
                        self.cart=[]
                    }
                }.resume()
        }
        
        }

}
