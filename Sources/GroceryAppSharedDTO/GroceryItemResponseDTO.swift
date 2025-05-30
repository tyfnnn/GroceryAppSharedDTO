//
//  File.swift
//  GroceryAppSharedDTO
//
//  Created by Tayfun Ilker on 30.05.25.
//

import Foundation

public struct GroceryItemResponseDTO: Codable, Sendable {
    public let id: UUID
    public let title: String
    public let price: Double
    public let quantity: Int
    
    public init(id: UUID, title: String, price: Double, quantity: Int) {
        self.id = id
        self.title = title
        self.price = price
        self.quantity = quantity
    }
}
