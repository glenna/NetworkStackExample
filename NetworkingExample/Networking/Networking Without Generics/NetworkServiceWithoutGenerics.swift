import Foundation

class NetworkOperationWithoutGenerics: Operation, NetworkOperationProtocol {
    var operationState: OperationState = .none {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
        }
        
        didSet {
            didChangeValue(forKey: operationState.rawValue)
        }
    }
    
    private let request: URLRequest
    private let completion: ((Result<Data?, NetworkError>) -> Void)?
    
    init(with apiRouter: APIRouter,
         completion: ((Result<Data?, NetworkError>) -> Void)? = nil) {
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
                self.completion?(Result.failure(NetworkError.error(error)))
            } else {
                self.completion?(Result.success(data))
            }
        }
        
        task.resume()
    }
    
    // MARK: operation state overrides
    
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
