import Foundation

struct Item: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var purchaseDate: Date
    var replaceIntervalMonths: Int
}
