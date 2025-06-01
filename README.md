# GroceryAppSharedDTO

A Swift package containing shared Data Transfer Objects (DTOs) for the GroceryApp ecosystem. This package ensures type safety and consistency between the iOS client and Vapor server by providing common data structures for API communication.

[🇩🇪 Deutsche Version](README_DE.md)

## 🔗 Related Repositories

- **iOS Client App**: [GroceryApp](https://github.com/tyfnnn/GroceryApp)
- **Vapor Server**: [grocery-app-server](https://github.com/tyfnnn/grocery-app-server)

## 📦 Package Overview

This Swift Package Manager (SPM) library provides shared data structures that eliminate the need to maintain duplicate model definitions across the client and server. All DTOs are designed to be `Codable`, `Sendable`, and platform-agnostic.

## 🎯 Why Shared DTOs?

### ✅ Benefits
- **Type Safety**: Compile-time guarantees for API contracts
- **DRY Principle**: Single source of truth for data structures
- **Consistency**: Identical models across client and server
- **Refactoring Safety**: Changes propagate automatically
- **Documentation**: Self-documenting API through type definitions

### 🚀 Alternative Approaches
Without shared DTOs, you would need to:
- Manually sync model definitions between projects
- Risk type mismatches and runtime errors
- Maintain duplicate validation logic
- Handle API changes in multiple places

## 📋 Available DTOs

### Authentication DTOs

#### `LoginResponseDTO`
Response structure for user login operations.
```swift
public struct LoginResponseDTO: Codable, Sendable {
    public let error: Bool
    public var reason: String?
    public var token: String?
    public var userId: UUID?
}
```

**Usage:**
- ✅ **Success**: `error: false`, includes `token` and `userId`
- ❌ **Failure**: `error: true`, includes descriptive `reason`

#### `RegisterResponseDTO`
Response structure for user registration operations.
```swift
public struct RegisterResponseDTO: Codable, Sendable {
    public let error: Bool
    public var reason: String?
}
```

**Usage:**
- ✅ **Success**: `error: false`
- ❌ **Failure**: `error: true`, includes descriptive `reason`

### Grocery Category DTOs

#### `GroceryCategoryRequestDTO`
Request payload for creating grocery categories.
```swift
public struct GroceryCategoryRequestDTO: Codable, Sendable {
    public let title: String
    public let colorCode: String
}
```

**Example:**
```swift
let categoryRequest = GroceryCategoryRequestDTO(
    title: "Fruits & Vegetables",
    colorCode: "#2ecc71"
)
```

#### `GroceryCategoryResponseDTO`
Response structure for grocery category operations.
```swift
public struct GroceryCategoryResponseDTO: Codable, Sendable {
    public let id: UUID
    public let title: String
    public let colorCode: String
}
```

**Features:**
- Includes server-generated `id`
- Used in lists and detail views
- Supports color-coded UI elements

### Grocery Item DTOs

#### `GroceryItemRequestDTO`
Request payload for creating grocery items.
```swift
public struct GroceryItemRequestDTO: Codable, Sendable {
    public let title: String
    public let price: Double
    public let quantity: Int
}
```

**Example:**
```swift
let itemRequest = GroceryItemRequestDTO(
    title: "Organic Apples",
    price: 3.99,
    quantity: 2
)
```

#### `GroceryItemResponseDTO`
Response structure for grocery item operations.
```swift
public struct GroceryItemResponseDTO: Codable, Sendable {
    public let id: UUID
    public let title: String
    public let price: Double
    public let quantity: Int
}
```

**Features:**
- Server-generated unique `id`
- Supports price tracking and inventory management
- Used in shopping lists and category details

## 💻 Installation

### Swift Package Manager

Add this package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/tyfnnn/GroceryAppSharedDTO.git", branch: "main")
]
```

Or in Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/tyfnnn/GroceryAppSharedDTO.git`
3. Select branch: `main`

### Import in Your Code

```swift
import GroceryAppSharedDTO

// Use any DTO
let loginResponse = LoginResponseDTO(error: false, token: "jwt_token", userId: UUID())
```

## 🛠️ Usage Examples

### iOS Client (SwiftUI)
```swift
import GroceryAppSharedDTO

class GroceryViewModel: ObservableObject {
    func createCategory(title: String, colorCode: String) async throws {
        let request = GroceryCategoryRequestDTO(title: title, colorCode: colorCode)
        let response: GroceryCategoryResponseDTO = try await apiClient.post(request)
        // Handle response...
    }
}
```

### Vapor Server
```swift
import GroceryAppSharedDTO
import Vapor

func saveGroceryCategory(req: Request) async throws -> GroceryCategoryResponseDTO {
    let requestDTO = try req.content.decode(GroceryCategoryRequestDTO.self)
    
    // Create and save category...
    let category = GroceryCategory(title: requestDTO.title, colorCode: requestDTO.colorCode)
    try await category.save(on: req.db)
    
    return GroceryCategoryResponseDTO(
        id: category.id!,
        title: category.title,
        colorCode: category.colorCode
    )
}
```

## 🔄 API Workflow Examples

### User Registration Flow
```swift
// 1. Client creates request
let registerRequest = ["username": "john", "password": "secret123"]

// 2. Server processes and responds
let registerResponse = RegisterResponseDTO(error: false)

// 3. Client handles response
if !registerResponse.error {
    // Navigate to login screen
}
```

### Category Management Flow
```swift
// 1. Create category
let categoryRequest = GroceryCategoryRequestDTO(title: "Dairy", colorCode: "#3498db")

// 2. Server responds with created category
let categoryResponse = GroceryCategoryResponseDTO(
    id: UUID(),
    title: "Dairy", 
    colorCode: "#3498db"
)

// 3. Add items to category
let itemRequest = GroceryItemRequestDTO(title: "Milk", price: 2.99, quantity: 1)
```

## 🏗️ Design Principles

### Consistency
- All DTOs follow consistent naming conventions
- Response DTOs always include server-generated IDs
- Error handling follows the same pattern across all operations

### Type Safety
- Leverages Swift's strong type system
- Compile-time validation of API contracts
- No magic strings or untyped dictionaries

### Sendability
- All DTOs conform to `Sendable` for safe concurrency
- Compatible with Swift's actor-based concurrency model
- Thread-safe by design

### Future-Proofing
- Designed for easy extension without breaking changes
- Optional properties for backward compatibility
- Clear separation between request and response models

## 📱 Platform Support

- ✅ **iOS 13.0+**
- ✅ **macOS 10.15+**
- ✅ **tvOS 13.0+**
- ✅ **watchOS 6.0+**
- ✅ **Linux** (for server-side usage)

## 🔍 Validation & Best Practices

### Client-Side Validation
```swift
extension GroceryCategoryRequestDTO {
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !colorCode.isEmpty
    }
}
```

### Server-Side Validation
The server should implement additional validation rules using Vapor's validation framework, while the DTOs provide the basic structure.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-dto`)
3. Add your changes with tests
4. Ensure backward compatibility
5. Update documentation
6. Submit a pull request

### Adding New DTOs

When adding new DTOs:
1. Follow existing naming conventions (`*RequestDTO`, `*ResponseDTO`)
2. Implement `Codable` and `Sendable`
3. Add comprehensive documentation
4. Include usage examples
5. Update version number appropriately

## 📚 Educational Value

This package demonstrates:
- **Swift Package Manager** best practices
- **API Design** patterns for mobile and server applications
- **Type-Safe Networking** implementation
- **Cross-Platform Development** with shared code
- **Modern Swift Concurrency** with Sendable protocols

## 🔄 Versioning Strategy

This package follows semantic versioning:
- **Major**: Breaking API changes
- **Minor**: New DTOs or backward-compatible additions
- **Patch**: Bug fixes and documentation updates

## 📄 License

This project is available for educational use. See LICENSE file for details.

---

🔗 Part of the GroceryApp ecosystem - demonstrating modern Swift development practices across client and server.
