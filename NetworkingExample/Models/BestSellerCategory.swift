import Foundation

struct BestSellerCategory: Codable {
    enum UpdateFrequency: String, Codable {
        case weekly = "WEEKLY"
        case monthly = "MONTHLY"
    }
    
    let displayName: String
    let listName: String
    let listNameEncoded: String
    let newestPublishedDate: String
    let oldestPublishedDate: String
    let updated: UpdateFrequency
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case listName = "list_name"
        case listNameEncoded = "list_name_encoded"
        case newestPublishedDate = "newest_published_date"
        case oldestPublishedDate = "oldest_published_date"
        case updated
    }
}
