import Foundation

struct BestSellersCategoryListResponse: Codable {
    let count: Int
    let list: [BestSellerCategory]
    
    enum CodingKeys: String, CodingKey {
        case count = "num_results"
        case list = "results"
    }
}
