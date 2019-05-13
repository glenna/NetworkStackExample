import Foundation

protocol APIRouter {
    var urlRequest: URLRequest { get }
}

enum NYTAPIRouter: APIRouter {
    case bestSellerCategories
    case bestSellersOverview(Date?)
    
    var urlRequest: URLRequest {
        let urlString: String = "\(host)\(route)?api-key=\(APIKeys.nyt)"
        let url: URL = URL(string: urlString)!
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = body
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return urlRequest
    }
    
    private var host: String {
        // normally would switch on Env here
        return "https://api.nytimes.com/svc/books/v3/"
    }
    
    private var route: String {
        switch self {
        case .bestSellerCategories:
            return "lists/names"
        case .bestSellersOverview:
            return "lists/overview"
        }
    }
    
    private var httpMethod: HTTPMethod {
        switch self {
        case .bestSellerCategories, .bestSellersOverview:
            return .get
        }
    }
    
    private var body: Data? {
        switch self {
        case .bestSellerCategories, .bestSellersOverview:
            return nil
        }
    }
}
