import Foundation

enum UserFacingError: Error {
    case networkError(NetworkError)
    case ladeeda
}

enum NYTBestSellersRequests {
    static func bestSellerCategories(completion: @escaping (Result<[BestSellerCategory], UserFacingError>) -> Void) {
        let op: NetworkOperation<BestSellersCategoryListResponse> = NetworkOperation<BestSellersCategoryListResponse>(with: NYTAPIRouter.bestSellerCategories) { result in
            switch result {
            case .success(let bestSellerList):
                guard let bestSellers: [BestSellerCategory] = bestSellerList?.list else {
                    completion(.failure(UserFacingError.ladeeda))
                    return
                }
                completion(.success(bestSellers))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        NetworkService.shared.add(op)
    }
    
    static func bestSellersList(completion: @escaping (Result<[BestSellersList], UserFacingError>) -> Void) {
        let op: NetworkOperation =  NetworkOperation<BestSellersOverviewResponse>(with: NYTAPIRouter.bestSellersOverview(nil)) { result in
            switch result {
            case .success(let bestSellersLists):
                guard let bestSellersLists: [BestSellersList] = bestSellersLists?.results.lists else {
                    completion(.failure(UserFacingError.ladeeda))
                    return
                }
                completion(.success(bestSellersLists))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        NetworkService.shared.add(op)
    }
}
