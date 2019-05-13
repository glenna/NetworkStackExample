import Foundation

struct BestSellersOverviewResponse: Codable {
    let results: BestSellersOverviewListContainer
}

struct BestSellersOverviewListContainer: Codable {
    let lists: [BestSellersList]
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case lists
        case date = "bestsellers_date"
    }
}

struct BestSellersList: Codable {
    let books: [Book]
    let displayName: String
    
    enum CodingKeys: String, CodingKey {
        case books
        case displayName = "display_name"
    }
}
