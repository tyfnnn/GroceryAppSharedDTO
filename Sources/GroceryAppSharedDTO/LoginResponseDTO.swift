//
//  File.swift
//  GroceryAppSharedDTO
//
//  Created by Tayfun Ilker on 29.05.25.
//

import Foundation

public struct LoginResponseDTO: Codable, Sendable {
    public let error: Bool
    public var reason: String? = nil
    public var token: String? = nil
    public var userId: UUID? = nil
    
    public init(error: Bool, reason: String? = nil, token: String? = nil, userId: UUID? = nil) {
        self.error = error
        self.reason = reason
        self.token = token
        self.userId = userId
    }
}

#if canImport(Vapor)
import Vapor
extension LoginResponseDTO: Content {}
#endif
