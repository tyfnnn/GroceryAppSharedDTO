//
//  File.swift
//  GroceryAppSharedDTO
//
//  Created by Tayfun Ilker on 30.05.25.
//

import Foundation

public struct GroceryCategoryRequestDTO: Codable, Sendable {
    public let title: String
    public let colorCode: String
    
    public init(title: String, colorCode: String) {
        self.title = title
        self.colorCode = colorCode
    }
}
