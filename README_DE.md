# GroceryAppSharedDTO

Ein Swift-Paket mit geteilten Data Transfer Objects (DTOs) für das GroceryApp-Ökosystem. Dieses Paket gewährleistet Typsicherheit und Konsistenz zwischen dem iOS-Client und dem Vapor-Server durch Bereitstellung gemeinsamer Datenstrukturen für die API-Kommunikation.

[🇺🇸 English Version](README.md)

## 🔗 Verwandte Repositories

- **iOS Client App**: [GroceryApp](https://github.com/tyfnnn/GroceryApp)
- **Vapor Server**: [grocery-app-server](https://github.com/tyfnnn/grocery-app-server)

## 📦 Paket-Übersicht

Diese Swift Package Manager (SPM) Bibliothek stellt geteilte Datenstrukturen bereit, die die Notwendigkeit eliminieren, doppelte Modelldefinitionen zwischen Client und Server zu pflegen. Alle DTOs sind so konzipiert, dass sie `Codable`, `Sendable` und plattformunabhängig sind.

## 🎯 Warum geteilte DTOs?

### ✅ Vorteile
- **Typsicherheit**: Compile-Time-Garantien für API-Verträge
- **DRY-Prinzip**: Single Source of Truth für Datenstrukturen
- **Konsistenz**: Identische Modelle zwischen Client und Server
- **Refactoring-Sicherheit**: Änderungen propagieren automatisch
- **Dokumentation**: Selbstdokumentierende API durch Typdefinitionen

### 🚀 Alternative Ansätze
Ohne geteilte DTOs müssten Sie:
- Modelldefinitionen manuell zwischen Projekten synchronisieren
- Riskieren von Typunstimmigkeiten und Laufzeitfehlern
- Doppelte Validierungslogik pflegen
- API-Änderungen an mehreren Stellen behandeln

## 📋 Verfügbare DTOs

### Authentifizierungs-DTOs

#### `LoginResponseDTO`
Antwortstruktur für Benutzeranmelde-Operationen.
```swift
public struct LoginResponseDTO: Codable, Sendable {
    public let error: Bool
    public var reason: String?
    public var token: String?
    public var userId: UUID?
}
```

**Verwendung:**
- ✅ **Erfolg**: `error: false`, enthält `token` und `userId`
- ❌ **Fehler**: `error: true`, enthält beschreibenden `reason`

#### `RegisterResponseDTO`
Antwortstruktur für Benutzerregistrierungs-Operationen.
```swift
public struct RegisterResponseDTO: Codable, Sendable {
    public let error: Bool
    public var reason: String?
}
```

**Verwendung:**
- ✅ **Erfolg**: `error: false`
- ❌ **Fehler**: `error: true`, enthält beschreibenden `reason`

### Lebensmittelkategorie-DTOs

#### `GroceryCategoryRequestDTO`
Request-Payload zum Erstellen von Lebensmittelkategorien.
```swift
public struct GroceryCategoryRequestDTO: Codable, Sendable {
    public let title: String
    public let colorCode: String
}
```

**Beispiel:**
```swift
let categoryRequest = GroceryCategoryRequestDTO(
    title: "Obst & Gemüse",
    colorCode: "#2ecc71"
)
```

#### `GroceryCategoryResponseDTO`
Antwortstruktur für Lebensmittelkategorie-Operationen.
```swift
public struct GroceryCategoryResponseDTO: Codable, Sendable {
    public let id: UUID
    public let title: String
    public let colorCode: String
}
```

**Features:**
- Enthält server-generierte `id`
- Verwendet in Listen und Detailansichten
- Unterstützt farbkodierte UI-Elemente

### Lebensmittelartikel-DTOs

#### `GroceryItemRequestDTO`
Request-Payload zum Erstellen von Lebensmittelartikeln.
```swift
public struct GroceryItemRequestDTO: Codable, Sendable {
    public let title: String
    public let price: Double
    public let quantity: Int
}
```

**Beispiel:**
```swift
let itemRequest = GroceryItemRequestDTO(
    title: "Bio-Äpfel",
    price: 3.99,
    quantity: 2
)
```

#### `GroceryItemResponseDTO`
Antwortstruktur für Lebensmittelartikel-Operationen.
```swift
public struct GroceryItemResponseDTO: Codable, Sendable {
    public let id: UUID
    public let title: String
    public let price: Double
    public let quantity: Int
}
```

**Features:**
- Server-generierte eindeutige `id`
- Unterstützt Preisverfolgung und Bestandsverwaltung
- Verwendet in Einkaufslisten und Kategorie-Details

## 💻 Installation

### Swift Package Manager

Fügen Sie dieses Paket zu Ihrer `Package.swift` hinzu:

```swift
dependencies: [
    .package(url: "https://github.com/tyfnnn/GroceryAppSharedDTO.git", branch: "main")
]
```

Oder in Xcode:
1. File → Add Package Dependencies
2. Eingeben: `https://github.com/tyfnnn/GroceryAppSharedDTO.git`
3. Branch auswählen: `main`

### Import in Ihrem Code

```swift
import GroceryAppSharedDTO

// Beliebiges DTO verwenden
let loginResponse = LoginResponseDTO(error: false, token: "jwt_token", userId: UUID())
```

## 🛠️ Verwendungsbeispiele

### iOS Client (SwiftUI)
```swift
import GroceryAppSharedDTO

class GroceryViewModel: ObservableObject {
    func createCategory(title: String, colorCode: String) async throws {
        let request = GroceryCategoryRequestDTO(title: title, colorCode: colorCode)
        let response: GroceryCategoryResponseDTO = try await apiClient.post(request)
        // Antwort behandeln...
    }
}
```

### Vapor Server
```swift
import GroceryAppSharedDTO
import Vapor

func saveGroceryCategory(req: Request) async throws -> GroceryCategoryResponseDTO {
    let requestDTO = try req.content.decode(GroceryCategoryRequestDTO.self)
    
    // Kategorie erstellen und speichern...
    let category = GroceryCategory(title: requestDTO.title, colorCode: requestDTO.colorCode)
    try await category.save(on: req.db)
    
    return GroceryCategoryResponseDTO(
        id: category.id!,
        title: category.title,
        colorCode: category.colorCode
    )
}
```

## 🔄 API-Workflow-Beispiele

### Benutzerregistrierungs-Ablauf
```swift
// 1. Client erstellt Request
let registerRequest = ["username": "john", "password": "geheim123"]

// 2. Server verarbeitet und antwortet
let registerResponse = RegisterResponseDTO(error: false)

// 3. Client behandelt Antwort
if !registerResponse.error {
    // Zur Anmeldeseite navigieren
}
```

### Kategorieverwaltungs-Ablauf
```swift
// 1. Kategorie erstellen
let categoryRequest = GroceryCategoryRequestDTO(title: "Milchprodukte", colorCode: "#3498db")

// 2. Server antwortet mit erstellter Kategorie
let categoryResponse = GroceryCategoryResponseDTO(
    id: UUID(),
    title: "Milchprodukte", 
    colorCode: "#3498db"
)

// 3. Artikel zur Kategorie hinzufügen
let itemRequest = GroceryItemRequestDTO(title: "Milch", price: 2.99, quantity: 1)
```

## 🏗️ Design-Prinzipien

### Konsistenz
- Alle DTOs folgen konsistenten Namenskonventionen
- Response-DTOs enthalten immer server-generierte IDs
- Fehlerbehandlung folgt dem gleichen Muster bei allen Operationen

### Typsicherheit
- Nutzt Swifts starkes Typsystem
- Compile-Time-Validierung von API-Verträgen
- Keine Magic Strings oder untypisierten Dictionaries

### Sendability
- Alle DTOs entsprechen `Sendable` für sichere Nebenläufigkeit
- Kompatibel mit Swifts actor-basiertem Nebenläufigkeitsmodell
- Thread-sicher by Design

### Zukunftssicherheit
- Entworfen für einfache Erweiterung ohne Breaking Changes
- Optionale Eigenschaften für Rückwärtskompatibilität
- Klare Trennung zwischen Request- und Response-Modellen

## 📱 Plattform-Unterstützung

- ✅ **iOS 13.0+**
- ✅ **macOS 10.15+**
- ✅ **tvOS 13.0+**
- ✅ **watchOS 6.0+**
- ✅ **Linux** (für serverseitige Verwendung)

## 🔍 Validierung & Best Practices

### Client-seitige Validierung
```swift
extension GroceryCategoryRequestDTO {
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !colorCode.isEmpty
    }
}
```

### Server-seitige Validierung
Der Server sollte zusätzliche Validierungsregeln mit Vapors Validierungs-Framework implementieren, während die DTOs die Grundstruktur bereitstellen.

## 🤝 Beitragen

1. Repository forken
2. Feature-Branch erstellen (`git checkout -b feature/new-dto`)
3. Ihre Änderungen mit Tests hinzufügen
4. Rückwärtskompatibilität sicherstellen
5. Dokumentation aktualisieren
6. Pull Request einreichen

### Neue DTOs hinzufügen

Beim Hinzufügen neuer DTOs:
1. Bestehende Namenskonventionen befolgen (`*RequestDTO`, `*ResponseDTO`)
2. `Codable` und `Sendable` implementieren
3. Umfassende Dokumentation hinzufügen
4. Verwendungsbeispiele einschließen
5. Versionsnummer entsprechend aktualisieren

## 📚 Bildungswert

Dieses Paket demonstriert:
- **Swift Package Manager** Best Practices
- **API-Design**-Muster für Mobile- und Server-Anwendungen
- **Typsichere Netzwerk**-Implementierung
- **Cross-Platform-Entwicklung** mit geteiltem Code
- **Moderne Swift Concurrency** mit Sendable-Protokollen

## 🔄 Versionierungsstrategie

Dieses Paket folgt semantischer Versionierung:
- **Major**: Breaking API-Änderungen
- **Minor**: Neue DTOs oder rückwärtskompatible Ergänzungen
- **Patch**: Bugfixes und Dokumentations-Updates

## 📄 Lizenz

Dieses Projekt ist für Bildungszwecke verfügbar. Siehe LICENSE-Datei für Details.

---

🔗 Teil des GroceryApp-Ökosystems - demonstriert moderne Swift-Entwicklungspraktiken zwischen Client und Server.
