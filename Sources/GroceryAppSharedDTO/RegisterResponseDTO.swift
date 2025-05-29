//
//  File.swift
//  GroceryAppSharedDTO
//
//  Created by Tayfun Ilker on 29.05.25.
//

import Foundation

struct RegisterResponseDTO: Codable {
    public let error: Bool
    public var reason: String? = nil
    
    public init(error: Bool, reason: String? = nil) {
        self.error = error
        self.reason = reason
    }
}
