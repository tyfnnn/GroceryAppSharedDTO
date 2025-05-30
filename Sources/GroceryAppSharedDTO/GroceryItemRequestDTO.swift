//
//  File.swift
//  GroceryAppSharedDTO
//
//  Created by Tayfun Ilker on 30.05.25.
//

import Foundation

public struct GroceryItemRequestDTO: Codable, Sendable {
    public let title: String
    public let price: Double
    public let quantity: Int
    
    init(title: String, price: Double, quantity: Int) {
        self.title = title
        self.price = price
        self.quantity = quantity
    }
}
