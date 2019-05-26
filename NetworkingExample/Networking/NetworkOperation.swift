import Foundation

enum OperationState: String {
    case none
    case ready = "isReady"
    case executing = "isExecuting"
    case finished = "isFinished"
}

protocol NetworkOperationProtocol: class {
    var operationState: OperationState { get set }
}

class NetworkOperation<T>: Operation, NetworkOperationProtocol where T: Decodable {
    var operationState: OperationState = .none {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
        }
        
        didSet {
            didChangeValue(forKey: operationState.rawValue)
        }
    }
    
    private let request: URLRequest
    private let completion: ((Result<T?, Error>) -> Void)?
    
    init(with apiRouter: APIRouter,
         completion: ((Result<T?, Error>) -> Void)? = nil) {
        self.request = apiRouter.urlRequest
        self.completion = completion
        operationState = .none
    }
    
    override func start() {
        if !isExecuting {
            operationState = .executing
            performRequest()
        }
    }
    
    private func performRequest() {
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error: Error = error {
                self.completion?(Result.failure(error))
            } else {
                guard let data: Data = data else {
                    self.completion?(Result.success(nil))
                    return
                }
                
                do {
                    let decoded: T = try JSONDecoder().decode(T.self, from: data)
                    self.completion?(Result.success(decoded))
                } catch {
                    self.completion?(Result.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    //MARK: operation state overrides
        
    override var isReady: Bool {
        return operationState == .ready
    }
    
    override var isExecuting: Bool {
        return operationState == .executing
    }
    
    override var isFinished: Bool {
        return operationState == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
}
