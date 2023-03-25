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

    var cart = [CartItem]()
    private var totalConsumed = LiveData<Float>(0.0)
    @Published var categories = [Category]()
    @Published var filteredMenuList: [MenuItem] = []
    var selectedMenuItems = LiveData<Set<MenuItem>>([])
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

   

    private var selectedCategory = LiveData<Category>(Category(itemId: "", itemName: "",classItem: "",siteId:"",depId:"",regDate: "",status: "",deleteFlag: ""))
    var selectedCategoryObserver: ((Category) -> Void)? {
        didSet {
            selectedCategory.observe { category in
                self.selectedCategoryObserver?(category)
                self.filterMenuListByCategory(category)
            }
        }
    }

    var serviceTables: [ServiceTable]? = nil

    private func filterMenuListByCategory(_ category: Category) {
        let filteredMenuList = menuList.value.filter { $0.item_id == category.itemId }
        let otherMenuList = menuList.value.filter { $0.item_id != category.itemId }
        self.filteredMenuList = filteredMenuList + otherMenuList
     
    }

    func filterMenuListByQuery(query: String) -> LiveData<[MenuItem]> {
        let liveData = LiveData<[MenuItem]>([])
        DispatchQueue.global(qos: .userInitiated).async {
            let filteredList = self.menuList.value
            let matchedList = filteredList.filter {
                $0.catg_name.localizedCaseInsensitiveContains(query) ||
                $0.item_name.localizedCaseInsensitiveContains(query)
            }
            let resultList = matchedList + filteredList.filter { !matchedList.contains($0) }
            liveData.value = resultList
        }
        
        return liveData
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
    func fetchAccompanimentsAndSauces(siteId: String, callback: @escaping ([Accompaniment]?, [Sauce]?) -> Void) {
        guard let url = URL(string: "\(Urls.baseUrl)others?site_id=\(siteId)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                callback(nil, nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("Invalid response")
                callback(nil, nil)
                return
            }
            
            guard let data = data else {
                print("No data returned")
                callback(nil, nil)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(AccompanimentSauceResponse.self, from: data)
                callback(response.accompaniments, response.sauces)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                callback(nil, nil)
            }
        }
        
        task.resume()
    }
    
    func fetchTables(siteId: Int, callback: @escaping ([ServiceTable]) -> Void) {
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
                let serviceTables = response.tables.map { ServiceTable(tbl_id: $0.tbl_id, tbl_no: $0.tbl_no) }
                callback(serviceTables)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                callback([])
            }
        }
        
        task.resume()
    }

    func getCategories(siteId: String, completion: @escaping (Result<[Category], Error>) -> Void) {
        guard let url = URL(string: "\(Urls.getCategories)?site_id=\(siteId)") else { return }
        print(url)
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
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
                if let jsonData = jsonString.data(using: .utf8) {
                    
                    
                    do {
                        
                        let jsonDecoder = JSONDecoder()
                        let categoryList = try jsonDecoder.decode(CategoriesResponse.self, from: jsonData)
                        
                        let categoriesResponse = try jsonDecoder.decode(CategoriesResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.categories = categoriesResponse.categories
                        }
                        completion(.success(categoriesResponse.categories))
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
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


}
