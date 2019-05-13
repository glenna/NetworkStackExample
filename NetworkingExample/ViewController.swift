import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        doShittyURLSessionStuff()
//        doAPIRouterStuff()
        
//        doNetworkOperationStuff()
        
//        doNetworkOperationGenericStuff()
        
        doNetworkOperationStuffTheWayWeWant()
        
        view.backgroundColor = .white
        
        let titleLabel: UILabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = "Hello, ✨"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func doShittyURLSessionStuff() {
        let bookListsURL: String = "https://api.nytimes.com/svc/books/v3/lists/names?api-key=\(APIKeys.nyt)"
        let url: URL = URL(string: bookListsURL)!
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        let dataTask: URLSessionTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                //Handle error
                //Show user something
                return
            }
            
            guard let data: Data = data else {
                return
            }
            
            //update UI based on that
            print(String(describing:String(data: data, encoding: .utf8)))
        }
        
        dataTask.resume()
    }
    
    private func doAPIRouterStuff() {
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: NYTAPIRouter.bestSellerCategories.urlRequest) { (data, response, error) in
            guard error == nil else {
                //Handle error
                //Show useer something
                return
            }
            
            guard let data: Data = data else {
                return
            }
            
            //update UI based on that
            print(String(describing:String(data: data, encoding: .utf8)))
        }
        
        dataTask.resume()
    }
    
    func doNetworkOperationStuff() {
        let op: NetworkOperationWithoutGenerics = NetworkOperationWithoutGenerics(apiRouter: NYTAPIRouter.bestSellerCategories) { result in
            switch result {
            case .success(let data):
                if let data: Data = data {
                    print(String(data: data, encoding: .utf8)!)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        NetworkService.shared.add(op)
    }
    
    func doNetworkOperationGenericStuff() {
let op: NetworkOperation<BestSellersCategoryListResponse, NetworkError> = NetworkOperation<BestSellersCategoryListResponse, NetworkError>(apiRouter: .bestSellerCategories) { result in
    switch result {
    case .success(let bestSellerList):
        print(String(describing:bestSellerList?.count))
        print(String(describing:bestSellerList?.list))
    case .failure(let error):
        print(error)
    }
}

NetworkService.shared.add(op)
    }

    func doNetworkOperationStuffTheWayWeWant() {
        NYTBestSellersRequests.bestSellerCategories { result in
            switch result {
            case .success(let bestSellerCategories):
                print("hey we have the lists ready for UI display \(bestSellerCategories.count)")
            case .failure(let error):
                print("aww shucks, time to show an error to the user \(error)")
            }
        }
        
        NYTBestSellersRequests.bestSellersList { result in
            switch result {
            case .success(let bestSellersLists):
                print("hey we have the lists ready for UI display \(bestSellersLists.count)")
            case .failure(let error):
                print("aww shucks, time to show an error to the user \(error)")
            }
        }
    }
}

