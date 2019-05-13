import Foundation

enum NetworkError: Error {
    case operationFailed
    case error(Error)
}

struct NetworkService {
    static let shared: NetworkService = NetworkService()
    
    let operationQueue: OperationQueue = OperationQueue()

    func add(_ operation: Operation & NetworkOperationProtocol) {
        operation.operationState = .ready
        operationQueue.addOperation(operation)
    }
}
