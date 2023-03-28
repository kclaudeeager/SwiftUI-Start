//
//  CartItemViewModel.swift
//  HelloWorld
//
//  Created by Claude KWIZERA on 3/28/23.
//

import Foundation

class CartItemViewModel: ObservableObject {
    @Published var cartItemCopy: CartItem
    init(cartItemCopy: CartItem) {
        self.cartItemCopy = cartItemCopy
    }
}
